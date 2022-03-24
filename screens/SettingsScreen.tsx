import { useContext, useEffect, useState } from 'react'
import { Button, StyleSheet, TextInput } from 'react-native'
import AsyncStorage from '@react-native-async-storage/async-storage'
import Toast from 'react-native-toast-message'

import { View } from '../components/Themed'
import { StoreContext } from '../store'
import { useNavigation } from '@react-navigation/native'
import { testConnection } from '../utils/webdav'

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  },
  input: {
    width: '100%'
  }
})

export default function SettingsScreen () {
  const { dispatch } = useContext(StoreContext)
  const navigate = useNavigation()
  const [serverUrl, setServerUrl] = useState('')
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')

  async function getSettings () {
    try {
      const _serverUrl = await AsyncStorage.getItem('serverUrl')
      if (_serverUrl) {
        setServerUrl(_serverUrl)
      }
      const _username = await AsyncStorage.getItem('username')
      if (_username) {
        setUsername(_username)
      }
      const _password = await AsyncStorage.getItem('password')
      if (_password) {
        setPassword(_password)
      }

      if (_serverUrl && _username && _password) {
        await testConnection(_serverUrl, _username, _password)
        dispatch({ type: 'SET_CREDENTIALS', payload: { serverUrl, username, password } })
        // TODO: add types
        navigate.navigate('Root' as any)
      }
    } catch (error) {
      Toast.show({
        type: 'error',
        text1: "Can't connect to server",
        text2: `${error}`
      })
    }
  }

  useEffect(() => {
    getSettings()
  }, [])

  async function connect () {
    try {
      await testConnection(serverUrl, username, password)
      await AsyncStorage.setItem('serverUrl', serverUrl)
      await AsyncStorage.setItem('username', username)
      await AsyncStorage.setItem('password', password)
      dispatch({ type: 'SET_CREDENTIALS', payload: { serverUrl, username, password } })
      // TODO: add types
      navigate.navigate('Root' as any)
    } catch (error) {
      Toast.show({
        type: 'error',
        text1: "Can't connect to server",
        text2: `${error}`
      })
    }
  }

  return (
    <View style={styles.container}>
      <TextInput style={styles.input} placeholder='server' value={serverUrl} onChangeText={setServerUrl} keyboardType='url' autoCorrect={false} />
      <TextInput style={styles.input} placeholder='username' value={username} onChangeText={setUsername} autoCorrect={false} />
      <TextInput style={styles.input} placeholder='password' accessibilityHint='*' value={password} onChangeText={setPassword} secureTextEntry autoCorrect={false} />
      <Button title='Connect' onPress={connect} />
    </View>
  )
}
