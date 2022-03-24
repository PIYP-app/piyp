import { createContext, Dispatch } from 'react'

type Store = {
  credentials: {
    serverUrl: string | undefined
    username: string | undefined
    password: string | undefined
  }
}

type Action = {
  type: 'SET_CREDENTIALS'
  payload: {
    serverUrl: string
    username: string
    password: string
  }
}

export const initialStore: Store = {
  credentials: {
    serverUrl: undefined,
    username: undefined,
    password: undefined
  }
}

export function reducer (state: Store, action: Action): Store {
  switch (action.type) {
    case 'SET_CREDENTIALS':
      return {
        ...state,
        credentials: {
          serverUrl: action.payload.serverUrl,
          username: action.payload.username,
          password: action.payload.password
        }
      }
    default:
      throw new Error("Action doesn't exist")
  }
}

export const StoreContext = createContext<{ state: Store; dispatch: Dispatch<Action> }>({ state: initialStore, dispatch: () => undefined })
