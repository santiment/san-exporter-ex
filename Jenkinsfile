@Library('podTemplateLib')

import net.santiment.utils.podTemplates

properties([
  buildDiscarder(
    logRotator(
      artifactDaysToKeepStr: '30', 
      artifactNumToKeepStr: '', 
      daysToKeepStr: '30', 
      numToKeepStr: ''
    )
  )
])

slaveTemplates = new podTemplates()

slaveTemplates.dockerComposeTemplate { label ->
  node(label) {
    container('docker-compose') {
      stage('Test') {
        try {
          sh "ls -la"
          sh "./bin/test.sh"
        } finally {
          sh "docker-compose -f docker-compose-test.yaml down -v"
        }
      }
    }
  }
}
