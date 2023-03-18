import React from "react";
import { createStackNavigator } from "@react-navigation/stack";

import { useAuth } from "../AuthProvider";
import LoginScreen from "../components/LoginScreen";
import MainTabNavigator from "./MainTabNavigator";


const Stack = createStackNavigator();

const AppNavigator = () => {

  const user = useAuth();

  if (!user) {
    return (
      <Stack.Navigator>
        <Stack.Screen
          name="Login"
          component={LoginScreen}
          options={{ title: "Log In" }}
        />
      </Stack.Navigator>
    );
  }

  return (
      <MainTabNavigator />
  );
};

export default AppNavigator;
