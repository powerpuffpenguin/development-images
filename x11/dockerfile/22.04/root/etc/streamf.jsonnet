{
  dialer: [
    {
      tag: 'x11vnc',
      timeout: '200ms',
      url: 'basic://',
      addr: '/tmp/x11vnc.socket',
      network: 'unix',
    },
  ],
  listener: [
    {
      network: 'tcp',
      addr: ':80',
      mode: 'http',
      router: [
        {
          method: 'WS',
          pattern: '/websockify',
          dialer: {
            tag: 'x11vnc',
            close: '1s',
          },
        },
        {
          method: 'FS',
          pattern: '/',
          fs: '/opt/noVNC',
        },
      ],
    },
  ],
}
