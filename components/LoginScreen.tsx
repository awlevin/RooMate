import React, { useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Input, Button } from '@rneui/themed';
import { createUserWithEmailAndPassword, signInWithEmailAndPassword } from 'firebase/auth';
import { auth } from '../firebaseConfig'; // Import the 'auth' instance from your firebase.ts or firebase.js file

const LoginScreen = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isSignUp, setIsSignUp] = useState(false);
  const [err, setErr] = useState('');

  const handleAuth = async () => {
    try {
      if (isSignUp) {
        await createUserWithEmailAndPassword(auth, email, password);
        console.log('User signed up successfully');
      } else {
        await signInWithEmailAndPassword(auth, email, password);
        console.log('User logged in successfully');
      }
    } catch (error) {
      console.error('Error during authentication:', error);
      setErr(error.message)
    }
  };

  return (
    <View style={styles.container}>
      <Text>{isSignUp ? 'Sign Up' : 'Log In'}</Text>
      <Input
        label="Email"
        value={email}
        onChangeText={(text) => setEmail(text)}
        keyboardType="email-address"
        textContentType="emailAddress"
      />
      <Input
        label="Password"
        value={password}
        onChangeText={(text) => setPassword(text)}
        secureTextEntry
        textContentType="password"
        errorMessage={err}
      />
      <Button
        title={isSignUp ? 'Sign Up' : 'Log In'}
        onPress={handleAuth}
      />
      <Button
        title={isSignUp ? 'Switch to Log In' : 'Switch to Sign Up'}
        type="outline"
        onPress={() => setIsSignUp(!isSignUp)}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default LoginScreen;
