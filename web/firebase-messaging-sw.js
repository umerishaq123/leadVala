
// importScripts("https://www.gstatic.com/firebasejs/10.3.0/firebase-app-compat.js");
// importScripts("https://www.gstatic.com/firebasejs/10.3.0/firebase-messaging-compat.js");
// importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
// importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");


importScripts("https://www.gstatic.com/firebasejs/9.22.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.22.2/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyBI-aSNeThH1f42tIDtDgehJQxztlFBYAQ",
    authDomain: "leadvala-b47d2.firebaseapp.com",
    projectId: "leadvala-b47d2",
    storageBucket: "leadvala-b47d2.appspot.com",
    messagingSenderId: "924265223964",
    appId: "1:924265223964:web:86b8a1306942fe83c90cd9"
});

const messaging = firebase.messaging();


// Background Message Handler
messaging.onBackgroundMessage((payload) => {
    console.log('📩 Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        icon: "/icons/Icon-192.png"
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});

// Initialize Firebase inside Service Worker
// firebase.initializeApp({
//     apiKey: "AIzaSyAfyD0--hbTJvB038snS0Mh6F4plsyRPRQ",
//     authDomain: "leadvala-b47d2.firebaseapp.com",
//     projectId: "leadvala-b47d2",
//     storageBucket: "leadvala.appspot.com",
//     messagingSenderId: "924265223964",
//     appId: "1:924265223964:web:4fe8ac5037164596c90cd9"
// });

// const messaging = firebase.messaging();

// // ✅ Handle Background Push Notifications
// messaging.onBackgroundMessage((payload) => {
//     console.log('📩 Received background message:', payload);
//     const notificationTitle = payload.notification.title;
//     const notificationOptions = {
//         body: payload.notification.body,
//         icon: '/icons/Icon-192.png'
//     };

//     self.registration.showNotification(notificationTitle, notificationOptions);
// });


// // Initialize Firebase in the Service Worker
// firebase.initializeApp({
//     apiKey: "AIzaSyAfyD0--hbTJvB038snS0Mh6F4plsyRPRQ",
//     appId: "1:924265223964:android:4fe8ac5037164596c90cd9",
//     messagingSenderId: "924265223964",
//     projectId: "leadvala-b47d2",
//     storageBucket: "leadvala.firebasestorage.app",
// });

// // Retrieve Firebase Messaging
// const messaging = firebase.messaging();
