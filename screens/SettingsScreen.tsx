import { StatusBar } from 'expo-status-bar'
import { useEffect, useState } from 'react'
import { Alert, Button, Platform, StyleSheet, TextInput } from 'react-native'

import { View } from '../components/Themed'
import AsyncStorage from '@react-native-async-storage/async-storage'

const styles = StyleSheet.create({
  container: {
    flex: 1
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold'
  },
  separator: {
    marginVertical: 30,
    height: 1,
    width: '80%'
  }
})

export default function SettingsScreen () {
  const [serverUrl, setServerUrl] = useState('')
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')

  async function getSettings () {
    try {
      const _serverUrl = await AsyncStorage.getItem('serverUrl')
      if (_serverUrl !== null) {
        setServerUrl(_serverUrl)
      }
      const _username = await AsyncStorage.getItem('username')
      if (_username !== null) {
        setUsername(_username)
      }
      const _password = await AsyncStorage.getItem('password')
      if (_password !== null) {
        setPassword(_password)
      }
    } catch (e) {}
  }

  useEffect(() => {
    getSettings()
  }, [])

  async function updateSettings () {
    try {
      await AsyncStorage.setItem('serverUrl', serverUrl)
      await AsyncStorage.setItem('username', username)
      await AsyncStorage.setItem('password', password)
    } catch (e) {
      Alert.alert('Error while saving preferences', String(e))
    }
  }

  return (
    <View style={styles.container}>
      <TextInput placeholder='server' value={serverUrl} onChangeText={setServerUrl} keyboardType='url' autoCorrect={false} />
      <TextInput placeholder='username' value={username} onChangeText={setUsername} />
      <TextInput placeholder='password' accessibilityHint='*' value={password} onChangeText={setPassword} secureTextEntry />
      <Button title='Connect' onPress={() => updateSettings()} />
      {/* Use a light status bar on iOS to account for the black space above the modal */}
      <StatusBar style={Platform.OS === 'ios' ? 'light' : 'auto'} />
    </View>
  )
}
