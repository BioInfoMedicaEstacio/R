
  #################################################################
  ##                                                             ##
  ##   _   _ _   _ ____ ___ __  __ _____   ____   ___  _  ___    ##
  ##  | \ | | | | | __ )_ _|  \/  | ____| |___ \ / _ \/ |/ _ \   ##
  ##  |  \| | | | |  _ \| || |\/| |  _|     __) | | | | | (_) |  ##
  ##  | |\  | |_| | |_) | || |  | | |___   / __/| |_| | |\__, |  ##
  ##  |_| \_|\___/|____/___|_|  |_|_____| |_____|\___/|_|  /_/   ##
  ##                      === NUBIME ====                        ##
  ##                        20-10-2019                           ##    
  ##                                                             ##
  ## Function created for importing csv files downloaded from    ##
  ## the sra database.                                           ##
  ##                                                             ##      
  #################################################################

IMPORT_CSV <- function(DIR){
  
    #
    # DIR = directory containing csv files
    #
  
    # list files with the extention .csv
    FILES <- list.files(DIR,full.names=TRUE, pattern="\\.csv$")
    
    EXCEPTIONfiles <- c()
    N <- 0
    
    for( f in FILES ){
          
        M <- paste(N,"reading file:",f)
        print(M)
        
        # import file to DF
        DF <- read.csv(f)
        
        # Process only exception files, which doesn't have 
        # 47 columns
        if( ncol(DF)!=47 ){
              # place the name of exception files inside the 
              # vector ERRORfiles
              ERRORfiles <- c(EXCEPTIONfiles,f)
              warning(paste("ATTENTION! File with different number of columns:",f))
              # counter used only for exception files
              N <- N+1
              # Jump to next iteraction
              next()
        }
        
        # if it is the first iteraction
        if( N==0 ){
              # create DFtotal using the informaton from DF[0]
              DFtotal <- DF
              # Counter used only for the first iteraction
              N <- N+1
              # Jump to next iteraction
              next()
        }
        
        # bind DF on the botton of DFtotal
        suppressWarnings(DFtotal <- rbind(DFtotal,DF))
        
        # counter used for files with 47 columns
        N <- N+1
        
    }
    
    # import and merge files with different number of columns
    for(f in EXCEPTIONfiles){
        DF <- read.csv(f)
        DFtotal <- merge(DFtotal,DF,all=T)
    }

    # remove lines containing header information
    GOOD <- !grepl("Run", DFtotal$Run)
    DFtotal <- DFtotal[GOOD,]
    
    return(DFtotal)

}

  #####################################################
