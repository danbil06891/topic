// Import the required Firebase modules
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize the Firebase Admin SDK
admin.initializeApp();

// Function to send a message to a specific device
exports.sendMessage = functions.https.onCall(async (data) => {
  const { senderId, receiverId, message } = data;

  const messagePayload = {
    notification: {
      title: "New Message",
      body: message,
    },
    data: {
      senderId: senderId,
      receiverId: receiverId,
      message: message,
    },
    token: receiverId, // Receiver's FCM token or topic
  };

  try {
    await admin.messaging().send(messagePayload);
    return { success: true };
  } catch (error) {
    return { success: false, error: error.message };
  }
});
