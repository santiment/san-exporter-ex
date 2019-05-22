podTemplate(label: 'san-exporter-ex-builder', containers: [
  containerTemplate(
    name: 'docker-compose',
    image: 'docker/compose:1.22.0',
    ttyEnabled: true,
    command: 'cat',
    envVars: [
      envVar(key: 'DOCKER_HOST', value: 'tcp://docker-host-docker-host:2375')
    ])
]) {
  node('san-exporter-ex-builder') {
    container('docker-compose') {
      stage('Test') {
          try {
            sh "docker-compose -f docker-compose-test.yaml build test"
            sh "docker-compose -f docker-compose-test.yaml run test"
          } finally {
            sh "docker-compose -f docker-compose-test.yaml down -v"
          }
      }
    }
  }
}

