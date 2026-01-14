#!/bin/bash
if [ "x$trace" = "xyes" ]
then
    set -x
fi

##############################################################################################
# Script Name:   common_funs.sh
#
# Description:   This script contains most commonly used functions for PASOE 
#
# Author:        ddasa
#
# Date:          10/05/2018
#
#
########
#
# Modified by: Santosh Behera  
#
# Modified date: 15-Jul-19
#
# Reason: Added support for oemanager.war deployment       
#	  Added support for masking https port for PASOE instance in out file
########
#
# Modified by: Santosh Behera
#
# Modified date: 9-dec-19
#
# Reason: Added support for deployment of WSM files
########
# Modified by: smunigal
#
# Modified date: Mon Aug 24 07:28:22 EDT 2020
#
# Reason: Added createDB function
########
# Modified by: smunigal
#
# Modified date: Tue Feb 23 07:48:58 EST 2021
#
# Reason: Added f_createOEAGInstance function
########
#
# Modified by: Santosh Behera
#
# Modified date: 26-Sep-22
#
# Reason: Added support to start OE db in ssl mode in f_createDB
#########
#
# Modified by: smunigal
# Modified date: Thu Jan 25 04:09:38 EST 2024
# Reason: Added f_deployWebApp  f_deployOEABLApp functions
#########
#
# Modified by: smunigal
# Modified date: Tue Feb 25 01:43:29 EST 2025G
# Reason: Added f_waitForFile functions
##############################
#
# Modified by: Santosh Behera
#
# Modified date: 2-May-25
#
# Reason: Added support for manager.war deployment
##############################
#
# Modified by: Santosh Behera
#
# Modified date: 30-Jul-25
#
# Reason: Added support for cetralized error file and categorization of errors
#	  Introduced f_checkError, f_errorCategory functions
##############################################################################################


#User defined functions
f_createPAOSEInstance()
{
        #$1 is the instance name

        #Store original work directory value
        orig_wrkdir=$WRKDIR

        #Changing WRKDIR value as pasman command is using it to create temp files
        WRKDIR=`pwd`
        # Fixup /cygdrive/x/... paths returned by pwd on Cygwin
        if $IS_CYGWIN; then
          WRKDIR=`cygpath -m $WRKDIR`
        fi
        export WRKDIR

        #Create instance
		date
        pasman create $1
		date

        #Check instance creation status
        f_checkStatus "PASOE instance $1 creation" $?

        #On Windows, need to handle case with UNC path
        #if $NT;then
	#	  mtapsv=`which _mproapsv${EXE}`; export mtapsv
	#	  if $IS_CYGWIN; then
	#		  mtapsv=`cygpath -m $mtapsv`; export mtapsv
	#	  fi
	#	  
	#	  CHARS_1_2=`echo ${mtapsv} | cut -b1-2`
	#	  if [ "x$CHARS_1_2" = "x//" ]
	 #     then
	#	      echo "Handling UNC PATH - copying _mproapsv to $1/bin"
	#		  instance_location="${WRKDIR}/${1}"; export instance_location
	#	      cp $mtapsv $instance_location/bin/                                                                                               
	#	      $1/bin/oeprop.bat AppServer.SessMgr.agentExecFile=$instance_location/bin/${mtapsv##*/} >/dev/null 2>&1
	#	  fi
	 #   fi
		
		
        #Change WRKDIR value to its original
        WRKDIR=$orig_wrkdir
		
		echo "==========================================================="
}

f_checkStatus()
{
        #$1 is the command description
        #$2 is the exit code of the command
        if [ "x$2" = "x0" ]
        then
                echo $1 "succeeded"
        else
                echo $1 "failed with exit code " $2
        fi
}

f_setFileExtension()
{
        if $IS_CYGWIN
        then
          EXT=".bat";export EXT
        else
          EXT=".sh";export EXT
        fi
		
		if [ "x$EXT" = "x" ]
		then
			f_checkStatus "Setting file extenstion" 1
		else
			f_checkStatus "Setting file extenstion" 0
		fi
		
		echo "==========================================================="
}

f_deploySOAP()
{
        #$1 is the instance name
        #$2 is the path to WSM file
        #$3 is the webapp name (default is ROOT)

        webapp_name=$3
        if [ "x$webapp_name" = "x" ]
        then
                webapp_name="ROOT"
        fi

        $1/bin/deploySOAP$EXT $2 $webapp_name

        #Don't check for status as PSC00363852 is not fixed in 12.0 yet
        #f_checkStatus "Deploying $2 into webapp $webapp_name in instance $1" $?
		
		echo "==========================================================="

}

f_deployREST()
{
        #$1 is the instance name
        #$2 is the path to REST .zip/.paar file
        #$3 is the webapp name (default is ROOT)

        webapp_name=$3
        if [ "x$webapp_name" = "x" ]
        then
                webapp_name="ROOT"
        fi

        $1/bin/deployREST$EXT $2 $webapp_name

        #Don't check for status as PSC00363852 is not fixed in 12.0 yet
        #f_checkStatus "Deploying $2 into webapp $webapp_name in instance $1" $?
		
		echo "==========================================================="

}

f_deployoemanager()
{
	$1/bin/tcman$EXT deploy $DLC/servers/pasoe/extras/oemanager.war
}

f_deploymanager()
{
	$1/bin/tcman$EXT deploy $DLC/servers/pasoe/extras/manager.war
}

f_deploywar()
{
        #$1 is the instance name
        #$2 is the path to war file
        $1/bin/tcman$EXT deploy $2 
}

f_deployWSM()
{
        #$1 is the instance name
        #$2 is the path to WSM files
        #$3 is the webapp name (default is ROOT)

        webapp_name=$3
        if [ "x$webapp_name" = "x" ]
        then
                webapp_name="ROOT"
        fi

        $1/bin/deploySOAP$EXT $2 $webapp_name

        #Don't check for status as PSC00363852 is not fixed in 12.0 yet
        f_checkStatus "Deploying $2 into webapp $webapp_name in instance $1" $?

}

f_modifyPASOEInstancePorts()
{
        #$1 - instance name
        #$2 - http_port
        #$3 - shut_port
        #$4 - https_port

        #Backup before modifying files
        cp $1/conf/catalina.properties $1/conf/catalina.properties.orig

        #Update ports in catalina.properties
        $1/bin/tcman$EXT config psc.as.http.port=$http_port
        f_checkStatus "Updating http port" $?
        $1/bin/tcman$EXT config psc.as.https.port=$https_port
        f_checkStatus "Updating https port" $?
        $1/bin/tcman$EXT config psc.as.shut.port=$shut_port
        f_checkStatus "Updating shutdown port" $?
		
		echo "==========================================================="

}

f_checkPASOEInstanceStart()
{
        #$1 is the instance name

        #Need current date in YYYY-MM-DD format as catalina logs are named as catalina.YYYY-MM-DD.log
        DATE=`date +%Y-%m-%d`

        CATALINA_LOG=catalina.$DATE.log

        MAX_TRIALS=50
        SLEEP_TIME=5
        trial=0

        startup_msg=`grep "Server startup" $1/logs/$CATALINA_LOG`
        until [ "x$startup_msg" != "x" ] || [ $trial -ge $MAX_TRIALS ]
        do
                sleep $SLEEP_TIME
                startup_msg=`grep "Server startup" $1/logs/$CATALINA_LOG`
                trial=`expr $trial + 1`
        done

        if [ $trial -ge $MAX_TRIALS ]
        then
                #Startup has failed
                f_checkStatus "Instance $1 startup" 1
        else
                #Startup succeeded
                f_checkStatus "Instance $1 startup" 0
        fi
		
}

f_getPorts()
{
        #Get required ports
        http_port=`getaport` && shut_port=`getaport` && https_port=`getaport`
		
		f_checkStatus "Getting http_port, https_port & shut_port" $?
		echo "==========================================================="
	HTTP=$http_port
        HTTPS=$https_port
        SHUTDOWN=$shut_port
        export HTTP HTTPS SHUTDOWN
}

f_freePorts()
{
        #Return reserved ports
        if [ "x$http_port" != "x" ]
        then
                retaport $http_port
        fi
        if [ "x$shut_port" != "x" ]
        then
                retaport $shut_port
        fi
        if [ "x$https_port" != "x" ]
        then
                retaport $https_port
        fi
		
		f_checkStatus "Return of reserved ports" 0
		echo "==========================================================="
}

f_startPASOEInstance()
{
        #$1 is the instance name
	$1/bin/tcman$EXT pasoestart -restart
        f_checkPASOEInstanceStart $1
		
		echo "==========================================================="

}

f_checkPASOEInstanceStop()
{
        #$1 is the instance name
        #Wait for some time
        sleep 5

        #Get process ids
        java_pid=`ps -ef | grep $LOGNAME | grep "${WRKDIR}" | grep $1 | grep "catalina" | awk '{print $2}'`
        proapsv_pid=`ps -ef | grep $LOGNAME | grep "${WRKDIR}" | grep $1 | grep "_mproapsv" | awk '{print $2}'`
        prosrv_pid=`ps -ef | grep $LOGNAME | grep "${WRKDIR}" | grep $1 | grep "_mprosrv" | awk '{print $2}'`

        #Killing hanging processes
        if [ "x$java_pid" != "x" ]
        then
                kill -9 $java_pid
        fi
        if [ "x$proapsv_pid" != "x" ]
        then
                kill -9 $proapsv_pid
        fi
        if [ "x$prosrv_pid" != "x" ]
        then
                kill -9 $prosrv_pid
        fi
}

f_errorCategory()
{
	# Check if the file exists and is not empty	
	if [ -s "$FILE_PATH" ]; then
	 while read -r JC_ERR; do
          grep "$JC_ERR" $FILE_PATH >> javaCommonError.err >> $ERROUT
         done < "$REF_FILE_PATH/javaCommonError"
	
	 while read -r JAVA_ERR; do
          grep "$JAVA_ERR" $FILE_PATH >> javaError.err
         done < "$REF_FILE_PATH/javaError"

	 while read -r PAS_ERR; do
          grep "$PAS_ERR" $FILE_PATH >> pasoeError.err
         done < "$REF_FILE_PATH/pasoeError"

	 while read -r SC_ERR; do
          grep "$SC_ERR" $FILE_PATH >> scriptError.err
         done < "$REF_FILE_PATH/scriptError"

	 while read -r INFRA_ERR; do
          grep "$INFRA_ERR" $FILE_PATH >> infraError.err
         done < "$REF_FILE_PATH/infraError"
	
	  if [ "x$debug" = "xyes" ] && [ -s "javaCommonError.err" ]
	  then
    	   while read -r JAVA_EXP; do
            FILENAME=$(echo "$JAVA_EXP" | cut -d ':' -f 1)
	    ST_LINE=$(echo "$JAVA_EXP" | awk -F ':' '{print $2}')
	    awk "NR >= $ST_LINE && NR < ($ST_LINE + 10)" "$FILENAME" >> javaException.err
	    echo "======================================================================================================" >> javaException.err
           done < "$WRKDIR/javaCommonError.err"
	  fi
	fi
}

f_checkError()
{
	FILE_PATH=$WRKDIR/errorAll.err
        REF_FILE_PATH=$RDLQA/tests/PASOE/pas_common_scripts/errorList
        ERROUT=$(ls -1 *.out | tail -1)
	
	cd $WRKDIR
	find . -type f \( -name "*.log" -o -name "*.out" -o -name "*.txt" \) | grep -v debug_freemach.log | grep -v "grep" | cut -c3- > allReqFile
	while read -r ALL_ERR; do
         grep -Hnif $REF_FILE_PATH/searchError $ALL_ERR >> errorAll.err 2>/dev/null
        done < "$WRKDIR/allReqFile"
	f_errorCategory
	if [ "$trace" != "yes" ]; then rm "allReqFile"; fi
	find . -type f -name "*.err" -empty -delete
}

f_stopPASOEInstance()
{
        #$1 is the instance name
	f_checkError
        SLEEP_TIME=30 #seconds

        $1/bin/tcman$EXT stop -F -w $SLEEP_TIME

        f_checkPASOEInstanceStop $1
		
		echo "==========================================================="

}

f_cleanPASOEInstance()
{
        #$1 is the instance name

        $1/bin/tcman$EXT clean

		#Check instance creation status
        f_checkStatus "PASOE instance clean" $?

}

f_filterHTTPPort()
{
        #$1 is the out file name
	if [ "x$http_port" != "x" ]
        then
        sed "s|$http_port|xxxx|g" $1 > $1.tmp
        mv $1.tmp $1
	fi

	if [ "x$https_port" != "x" ]
	then
        sed "s|$https_port|xxxx|g" $1 > $1.tmp
        mv $1.tmp $1
	fi
}

f_updateOeablSecurityprop()
{
        #$1 is the out file name
		#$2 is the property name
		#$3 is the value for the property ($2)
		#$4 is the level - instance|app
	
		if [ "x$4" = "xinstance" ] || [ "x$4" = "xapp" ]
		then
			if [ "x$4" = "xinstance" ]
			then
				sed "s|$2=.*|$2=$3|g" $1/conf/oeablSecurity.properties > oeablSecurity.properties.fntmp
				mv oeablSecurity.properties.fntmp $1/conf/oeablSecurity.properties
			else
				sed "s|$2=.*|$2=$3|g" $1/webapps/ROOT/WEB-INF/oeablSecurity.properties > oeablSecurity.properties.fntmp
				mv oeablSecurity.properties.fntmp $1/webapps/ROOT/WEB-INF/oeablSecurity.properties
			fi
			f_checkStatus "Updating oeablSecurity.properties" 0
		else
			f_checkStatus "Updating oeablSecurity.properties" 1
		fi
		
		echo "==========================================================="
}

f_setFileExtension

f_createDB()
{
        #$1 is the DB name
		#$2 is the target DB (eg: sports, sports2000)

        #Store original work directory value
        orig_wrkdir=$WRKDIR

        #Changing WRKDIR value as pasman command is using it to create temp files
        WRKDIR=`pwd`
        # Fixup /cygdrive/x/... paths returned by pwd on Cygwin
        if $IS_CYGWIN; then
          WRKDIR=`cygpath -m $WRKDIR`
        fi
        export WRKDIR

		#Create database
		DB_NAME=$1
		export DB_NAME
		$PRODB $DB_NAME $2
		
		#Reserve a port to start db
		DB_PORT=`getaport`
		export DB_PORT
		if [ "x$3" = "xssl" ]
		then
			$PROSERVE $DB_NAME -ssl -S $DB_PORT
		else
			$PROSERVE $DB_NAME -S $DB_PORT
		fi

		#Check if db started
		if [ $? -ne 0 ] 
		then
			echo "Database startup failed"
			retaport $DB_PORT
			exit 1
		fi
		
		echo "==========================================================="
}

f_shutdownDB()
{
		#Shut down db
		$PROSHUT $DB_NAME -by
		if [ $? -ne 0 ]
		then
				echo "DB shut down failed"
				retaport $DB_PORT
				exit 1
		fi

#Return db port
retaport $DB_PORT
		
		echo "==========================================================="
}

f_createOEAGInstance()
{
        #Store original work directory value
        orig_wrkdir=$WRKDIR

        #Changing WRKDIR value as pasman command is using it to create temp files
        WRKDIR=`pwd`
        # Fixup /cygdrive/x/... paths returned by pwd on Cygwin
        if $IS_CYGWIN; then
          WRKDIR=`cygpath -m $WRKDIR`
        fi
        export WRKDIR
  
        oe_version=`cat $RDLSRC/config/Progressversioninfo.h | grep "DEF_DOTTED_VERSION" | cut -d " " -f3`;

        #Create an OEAG instance
        # Copy an oeag instance from dlc and register it.
		cp $DLC/servers/redist/oeauthgateway-$oe_version.zip $WRKDIR/
		
		cd $WRKDIR
		unzip oeauthgateway-$oe_version.zip

		chmod -R 777 $WRKDIR/oeauthserver

		pasman register oeauthserver $WRKDIR/oeauthserver

        #Check OEAG instance register status
        f_checkStatus "OEAG instance oeauthserver registration" $?

        #Change WRKDIR value to its original
        WRKDIR=$orig_wrkdir

                echo "==========================================================="
}

f_deployWebApp()
{
        #$1 is the instance name
        #$2 is the webapp name
        #$3 is the oeabl app name (default is instance name)

        oeablapp_name=$3

        $1/bin/tcman$EXT deploy -a $2 $DLC/servers/pasoe/extras/oeabl.war $oeablapp_name

        #check status
        f_checkStatus "Deploying $2 into ablapp $oeablapp_name in instance $1" $?

                echo "==========================================================="
}

f_deployOEABLApp()
{
        #$1 is the instance name
        #$2 is the oeabl app name

        oeablapp_name=$2

        $1/bin/tcman$EXT deploy $DLC/servers/pasoe/extras/oeabl.war $oeablapp_name

        #check status
        f_checkStatus "Deploying $oeablapp_name in instance $1" $?

                echo "==========================================================="
}

# Function to wait until a file exists or timeout after a specified duration
f_waitForFile() {
    local file_path="$1"
    local interval="${2:-1}"  # Default interval is 1 second if not provided
    local timeout="${3:-30}"  # Default timeout is 30 seconds if not provided
    local elapsed=0

    echo "Waiting for file: $file_path with a timeout of $timeout seconds"

    while [ ! -f "$file_path" ]; do
        sleep "$interval"
        elapsed=$((elapsed + interval))
        if [ "$elapsed" -ge "$timeout" ]; then
            echo "Timeout reached: $file_path not found after $timeout seconds."
            return 1
        fi
    done

    echo "File found: $file_path"
    return 0
}

#End of user defined functions
