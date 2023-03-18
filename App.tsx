import React from "react";
import { View } from "react-native";
import { AuthProvider } from "./AuthProvider";
import { SafeAreaProvider } from 'react-native-safe-area-context';

import MainApp from "./MainApp";

const App = () => {
  return (
    <AuthProvider>
      <View style={{ flex: 1 }}>
        <SafeAreaProvider>
          <MainApp />
        </SafeAreaProvider>
      </View>
    </AuthProvider>
  );
};

export default App;
