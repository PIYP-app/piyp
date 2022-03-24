import { StatusBar } from 'expo-status-bar'
import { useReducer } from 'react'
import { SafeAreaProvider } from 'react-native-safe-area-context'
import Toast from 'react-native-toast-message'

import useCachedResources from './hooks/useCachedResources'
import useColorScheme from './hooks/useColorScheme'
import Navigation from './navigation'
import { initialStore, reducer, StoreContext } from './store'

export default function App () {
  const isLoadingComplete = useCachedResources()
  const colorScheme = useColorScheme()
  const [state, dispatch] = useReducer(reducer, initialStore)

  if (!isLoadingComplete) {
    return null
  } else {
    return (
      <SafeAreaProvider>
        <StoreContext.Provider value={{ state, dispatch }}>
          <Navigation colorScheme={colorScheme} />
          <StatusBar />
          <Toast />
        </StoreContext.Provider>
      </SafeAreaProvider>
    )
  }
}
