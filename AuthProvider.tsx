// AuthProvider.js
import React, { createContext, useState, useEffect } from "react";
import { View } from "react-native";
import { auth } from "./firebaseConfig";
import { Text } from '@rneui/themed';
import { User as FirebaseUser } from "firebase/auth";

export const AuthContext = createContext<FirebaseUser | null>(null);

export type User = {
  uid: string;
  email: string;
};

export const useAuth = () => {
  return React.useContext(AuthContext);
}

export const AuthProvider = ({ children }) => {
  const [currentUser, setCurrentUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged((user) => {
      setCurrentUser(user);
      setLoading(false);
    });

    return unsubscribe;
  }, []);

  if (loading) {
    return (
      <View><Text>Loading...</Text></View>
    );
  }

  return (
    <AuthContext.Provider value={currentUser}>
      {children}
    </AuthContext.Provider>
  );
};
