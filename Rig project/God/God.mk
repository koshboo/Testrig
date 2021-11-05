##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=God
ConfigurationName      :=Debug
WorkspacePath          :="/home/pi/Desktop/Test_area/Testrig/Rig project"
ProjectPath            :="/home/pi/Desktop/Test_area/Testrig/Rig project/God"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=
Date                   :=05/11/21
CodeLitePath           :=/home/pi/.codelite
LinkerName             :=/usr/bin/g++
SharedObjectLinkerName :=/usr/bin/g++ -shared -fPIC
ObjectSuffix           :=.o
DependSuffix           :=.o.d
PreprocessSuffix       :=.i
DebugSwitch            :=-g 
IncludeSwitch          :=-I
LibrarySwitch          :=-l
OutputSwitch           :=-o 
LibraryPathSwitch      :=-L
PreprocessorSwitch     :=-D
SourceSwitch           :=-c 
OutputFile             :=$(IntermediateDirectory)/$(ProjectName)
Preprocessors          :=
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E
ObjectsFileList        :="God.txt"
PCHCompileFlags        :=
MakeDirCommand         :=mkdir -p
LinkOptions            :=  
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). $(IncludeSwitch)/home/aron/Desktop/Test_area/LIBS/ 
IncludePCH             := 
RcIncludePath          := 
Libs                   := $(LibrarySwitch)hiredis $(LibrarySwitch)sqlite3 
ArLibs                 :=  "hiredis" "sqlite3" 
LibPath                := $(LibraryPathSwitch). $(LibraryPathSwitch)/home/aron/Desktop/Test_area/LIBS/ 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := /usr/bin/ar rcu
CXX      := /usr/bin/g++
CC       := /usr/bin/gcc
CXXFLAGS :=  -g -O0 -std=c99 -Wall $(Preprocessors)
CFLAGS   :=  -g -O0 -Wall $(Preprocessors)
ASFLAGS  := 
AS       := /usr/bin/as


##
## User defined environment variables
##
CodeLiteDir:=/usr/share/codelite
Objects0=$(IntermediateDirectory)/main.c$(ObjectSuffix) $(IntermediateDirectory)/up_up_LIBS_Helpers.c$(ObjectSuffix) $(IntermediateDirectory)/up_up_LIBS_redis_helper.c$(ObjectSuffix) $(IntermediateDirectory)/up_up_LIBS_Core.c$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild MakeIntermediateDirs
all: $(OutputFile)

$(OutputFile): $(IntermediateDirectory)/.d $(Objects) 
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects0)  > $(ObjectsFileList)
	$(LinkerName) $(OutputSwitch)$(OutputFile) @$(ObjectsFileList) $(LibPath) $(Libs) $(LinkOptions)

MakeIntermediateDirs:
	@test -d ./Debug || $(MakeDirCommand) ./Debug


$(IntermediateDirectory)/.d:
	@test -d ./Debug || $(MakeDirCommand) ./Debug

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/main.c$(ObjectSuffix): main.c $(IntermediateDirectory)/main.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/pi/Desktop/Test_area/Testrig/Rig project/God/main.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/main.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/main.c$(DependSuffix): main.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/main.c$(ObjectSuffix) -MF$(IntermediateDirectory)/main.c$(DependSuffix) -MM main.c

$(IntermediateDirectory)/main.c$(PreprocessSuffix): main.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/main.c$(PreprocessSuffix) main.c

$(IntermediateDirectory)/up_up_LIBS_Helpers.c$(ObjectSuffix): ../../LIBS/Helpers.c $(IntermediateDirectory)/up_up_LIBS_Helpers.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/pi/Desktop/Test_area/Testrig/LIBS/Helpers.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_LIBS_Helpers.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_LIBS_Helpers.c$(DependSuffix): ../../LIBS/Helpers.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_LIBS_Helpers.c$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_LIBS_Helpers.c$(DependSuffix) -MM ../../LIBS/Helpers.c

$(IntermediateDirectory)/up_up_LIBS_Helpers.c$(PreprocessSuffix): ../../LIBS/Helpers.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_LIBS_Helpers.c$(PreprocessSuffix) ../../LIBS/Helpers.c

$(IntermediateDirectory)/up_up_LIBS_redis_helper.c$(ObjectSuffix): ../../LIBS/redis_helper.c $(IntermediateDirectory)/up_up_LIBS_redis_helper.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/pi/Desktop/Test_area/Testrig/LIBS/redis_helper.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_LIBS_redis_helper.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_LIBS_redis_helper.c$(DependSuffix): ../../LIBS/redis_helper.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_LIBS_redis_helper.c$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_LIBS_redis_helper.c$(DependSuffix) -MM ../../LIBS/redis_helper.c

$(IntermediateDirectory)/up_up_LIBS_redis_helper.c$(PreprocessSuffix): ../../LIBS/redis_helper.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_LIBS_redis_helper.c$(PreprocessSuffix) ../../LIBS/redis_helper.c

$(IntermediateDirectory)/up_up_LIBS_Core.c$(ObjectSuffix): ../../LIBS/Core.c $(IntermediateDirectory)/up_up_LIBS_Core.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/pi/Desktop/Test_area/Testrig/LIBS/Core.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_up_LIBS_Core.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_up_LIBS_Core.c$(DependSuffix): ../../LIBS/Core.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_up_LIBS_Core.c$(ObjectSuffix) -MF$(IntermediateDirectory)/up_up_LIBS_Core.c$(DependSuffix) -MM ../../LIBS/Core.c

$(IntermediateDirectory)/up_up_LIBS_Core.c$(PreprocessSuffix): ../../LIBS/Core.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_up_LIBS_Core.c$(PreprocessSuffix) ../../LIBS/Core.c


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Debug/


