#! /usr/bin/env bash
function printMenu() {
    echo "------------------------------"
    echo "| Hyper Commander            |"
    echo "| 0: Exit                    |"
    echo "| 1: OS info                 |"
    echo "| 2: User info               |"
    echo "| 3: File and Dir operations |"
    echo "| 4: Find Executables        |"
    echo "------------------------------"
}

function printFileMenu() {
    echo "---------------------------------------------------"
    echo "| 0 Main menu | 'up' To parent | 'name' To select |"
    echo "---------------------------------------------------"
}

function printFileOptions() {
    echo "---------------------------------------------------------------------"
    echo "| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |"
    echo "---------------------------------------------------------------------"
}

echo "Hello $USER!"

while true
do
    printMenu
    read input
    
    if [ $input -eq 0 ]; then
        echo "Farewell!"
        break;
    elif [ $input -eq 1 ]; then
        uname -o -n
    elif [ $input -eq 2 ]; then
        whoami
    elif [ $input -eq 3 ]; then
        while true
        do
            echo "The list of files and directories:"
            arr=(*)
            for item in "${arr[@]}"; do
              if [[ -f "$item" ]]; then
                echo "F $item"
              elif [[ -d "$item" ]]; then
                echo "D $item"
              fi
            done

            printFileMenu
            read option
            export control=0
       
            if [ "$option" = "0" ]; then
                    break;
            elif [ $option = "up" ]; then
                cd ..
            else
                for item in "${arr[@]}"; do
                    if [ $option = $item ]; then
                        export control=1
                    fi
                done
            
                if [ $control -eq 1 ]; then
                    if [[ -d "$option" ]]; then
                        cd $option
                    elif [[ -f "$option" ]]; then
                        while true
                        do
                            printFileOptions
                            read fileOption
    
                            if [ $fileOption -eq 0 ]; then
                                break;
                            elif [ $fileOption -eq 1 ]; then
                                rm $option
                                echo "$option has been deleted."
                                break;
                            elif [ $fileOption -eq 2 ]; then
                                echo "Enter the new file name:"
                                read newFileName
                                mv $option $newFileName
                                echo "$option has been renamed as $newFileName"
                                break;
                            elif [ $fileOption -eq 3 ]; then
                                chmod 666 $option
                                echo "Permissions have been updated."
                                ls -l | grep $option
                                break;
                            elif [ $fileOption -eq 4 ]; then
                                chmod 664 $option
                                echo "Permissions have been updated."
                                ls -l | grep $option
                                break;
                            fi
                        done
                    fi
                else
                    echo "Invalid input!"
                fi
            fi
        done
    
    elif [ $input -eq 4 ]; then
        echo "Enter an executable name:"
        read executableName
        export executablePath=$(which $executableName)

        if [ "$executablePath" = "" ]; then
            echo "The executable with that name does not exist!"
        else
            echo "Located in: $executablePath"
            echo "Enter arguments:"
            read arguments
            $executablePath $arguments
        fi
    else
        echo "Invalid option!"
    fi
done
