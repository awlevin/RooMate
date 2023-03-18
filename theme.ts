import { createTheme } from '@rneui/themed';

const theme = createTheme({
  lightColors: {
    primary: '#3498db',
    secondary: '#8e44ad',
    error: '#e74c3c',
    success: '#2ecc71',
    warning: '#f1c40f',
  },
  darkColors: {
    primary: '#3498db',
    secondary: '#8e44ad',
    error: '#e74c3c',
    success: '#2ecc71',
    warning: '#f1c40f',
  },
  mode: 'light', // Use 'light' or 'dark' mode
});

export default theme;
