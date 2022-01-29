const functions = require("firebase-functions");

exports.createUser = functions.firestore
    .document("chat/{message}")
    .onCreate((snap, context) => {
      console.log(snap.data());
      return;
    });
