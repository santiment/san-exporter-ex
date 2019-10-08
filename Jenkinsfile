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
          sh "docker-compose -f docker-compose-test.yaml build test"
          sh "docker-compose -f docker-compose-test.yaml run test"
        } finally {
          sh "docker-compose -f docker-compose-test.yaml down -v"
        }
      }
    }
  }
}
