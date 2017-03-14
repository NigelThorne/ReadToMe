ssl_bind '0.0.0.0', '7732', {
    key: "./server.key",
    cert: "./server.crt",
    verify_mode: 'none'
  }
preload_app!