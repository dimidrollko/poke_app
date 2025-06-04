const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

exports.recordDiscovery = functions.https.onCall({ region: 'europe-central2' }, async (data, context) => {
  const uid = data.auth?.uid;
  functions.logger.info("Function called", { structuredData: true });
  functions.logger.info("Data received:", data, { structuredData: true });

  if (!uid) {
    functions.logger.info("uid", uid);
    throw new functions.https.HttpsError(
      'unauthenticated',
      'Login required'
    );
  } else {
    functions.logger.info("UID received:", uid, { structuredData: true });
  }

  // --- Input validation ---
  const { entity_id, duration, is_correct } = data.data;
  functions.logger.info("entity_id, duration, is_correct", { entity_id, duration, is_correct }, { structuredData: true });
  if (typeof entity_id !== 'number' || isNaN(entity_id)) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      '`entity_id` must be a non-empty string'
    );
  }
  if (typeof duration !== 'number' || duration < 0) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      '`duration` must be a non-negative number'
    );
  }
  if (typeof is_correct !== 'boolean') {
    throw new functions.https.HttpsError(
      'invalid-argument',
      '`is_correct` must be a boolean'
    );
  }
  functions.logger.info("Validation Passed");

  // --- References ---
  const userRef = db.collection('users').doc(uid);
  functions.logger.info("DB Received");
  const leaderboardRef = db
    .collection('leaderboard_summary')
    .doc(uid);

  functions.logger.info("DB Received");

  // --- Read existing user data ---
  const userSnap = await userRef.get();

  const userData = userSnap.exists ? userSnap.data() : {};

  let currentStreak = userData.current_streak || 0;
  let longestStreak = userData.longest_streak || 0;

  // --- Update streaks based on correctness ---
  if (is_correct) {
    currentStreak += 1;
    longestStreak = Math.max(longestStreak, currentStreak);
  } else {
    currentStreak = 0;
  }

  // --- Batch updates for atomicity ---
  const batch = db.batch();

  // Always update streaks on the user document
  batch.set(
    userRef,
    {
      current_streak: currentStreak,
      longest_streak: longestStreak,
    },
    { merge: true }
  );

  if (is_correct) {
    // Only when correct do we record the discovery and increment leaderboard
    const newEntity = {
      id: entity_id,
      duration,
      timestamp: admin.firestore.Timestamp.now(),
    };

    batch.update(userRef, {
      discovered_entities:
        admin.firestore.FieldValue.arrayUnion(newEntity),
    });

    batch.set(
      leaderboardRef,
      {
        username: userData.username || 'unknown',
        discovered_count:
          admin.firestore.FieldValue.increment(1),
        longest_streak: longestStreak,
      },
      { merge: true }
    );
  }

  // Commit everything
  return batch.commit(); // RETURN THIS PROMISE
});

exports.createUserProfile = functions.https.onCall({ region: 'europe-central2' }, async (data, context) => {
  functions.logger.info("Function called", { structuredData: true });
  functions.logger.info("Data received:", data, { structuredData: true });
  const uid = data.auth?.uid;
  functions.logger.info("UID:", uid, { structuredData: true });
  if (!uid) {
    functions.logger.error("Authentication failed: Login required", { structuredData: true });
    throw new functions.https.HttpsError("unauthenticated", "Login required");
  }

  const { username, email, avatar, discovered } = data.data;
  functions.logger.info(`username ${username}, email: ${email}, avatar: ${avatar}`);

  if (!username || !email) {
    functions.logger.warn("Missing username or email", { structuredData: true });
    throw new functions.https.HttpsError("invalid-argument", "Username and email are required.");
  }

  const userRef = db.collection("users").doc(uid);
  functions.logger.info(`userRef ${userRef}`);
  const doc = await userRef.get();
  functions.logger.info(`doc ${doc}`);

  if (doc.exists) {
    functions.logger.warn("User profile already exists.", { structuredData: true });
    throw new functions.https.HttpsError("already-exists", "User profile already exists.");
  }

  const initialDiscovery = {
    id: 1,
    duration: 0,
    timestamp: admin.firestore.Timestamp.now(),
  };
  const discoveredWithTimestamp = discovered ? {
    ...discovered,
    timestamp: admin.firestore.Timestamp.now(),
  } : initialDiscovery;

  functions.logger.info(`initialDiscovery ${initialDiscovery}`);

  await userRef.set({
    username,
    email,
    avatar: avatar || null,
    discovered_entities: [discoveredWithTimestamp],
    current_streak: 1,
    longest_streak: 1,
  });

  await db.collection("leaderboard_summary").doc(uid).set({
    username,
    discovered_count: 1,
    longest_streak: 1,
  });
  functions.logger.info(`function completed successfully`);

  return { success: true };
});

