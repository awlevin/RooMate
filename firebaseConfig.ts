import firebase, { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import "firebase/database";
import { getFirestore } from "firebase/firestore";
import "firebase/functions";
import "firebase/storage";

const firebaseConfig = {
  apiKey: "AIzaSyDl5T4N6Lf8kuoFkvnMjJgtiYzZPbEOjtY",
  authDomain: "roomate-4d59b.firebaseapp.com",
  projectId: "roomate-4d59b",
  storageBucket: "roomate-4d59b.appspot.com",
  messagingSenderId: "1004845477282",
  appId: "1:1004845477282:web:a64ef3ccf43d202cfbd6fb",
  measurementId: "G-EGJ5HNG4LH"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);

