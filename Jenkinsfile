#!groovy
import groovy.json.JsonSlurperClassic
node {

    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    def HUB_ORG=env.HUB_ORG_DH
    def SFDC_HOST = env.SFDC_HOST_DH
    def JWT_KEY_CRED_ID = env.JWT_CRED_ID_DH
    def CONNECTED_APP_CONSUMER_KEY=env.CONNECTED_APP_CONSUMER_KEY_DH

    println 'KEY IS' 
    println JWT_KEY_CRED_ID
    println HUB_ORG
    println SFDC_HOST
    println CONNECTED_APP_CONSUMER_KEY
    def toolbelt = tool 'toolbelt'

    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Retrieve Code') {
            if (isUnix()) {
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            }else{
                 rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            }
            if (rc != 0) { error 'hub org authorization failed' }

			println rc
			
			// need to pull out assigned username
			if (isUnix()) {
				rtc = sh returnStdout: true, script: "${toolbelt} force:mdapi:retrieve  -u ${HUB_ORG} -k manifest/package.xml -r manifest/"
                uz = bat returnStdout: true, script: "${toolbelt}unzip manifest/unpackaged.zip -d"  
                sc = bat returnStdout: true, script: "${toolbelt} force:mdapi:convert -r unpackaged/ -d force-app/"
			}else{
			   rtc = bat returnStdout: true, script: "\"${toolbelt}\" force:mdapi:retrieve  -u ${HUB_ORG} -k manifest/package.xml -r manifest/"
               uz = bat returnStdout: true, script: "zipFile manifest/unpackaged.zip"  
               sc = bat returnStdout: true, script: "\"${toolbelt}\" force:mdapi:convert -r unpackaged/ -d force-app/"
			}

              
            //printf rmsg
            println('Hello from a Job DSL script!')
            println(rtc)
        }
    }
}
