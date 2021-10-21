##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=Controller
ConfigurationName      :=Debug
WorkspacePath          := "/home/aron/Desktop/Test_area/Rig project"
ProjectPath            := "/home/aron/Desktop/Test_area/Rig project/Controller"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=Aron Jones
Date                   :=10/21/21
CodeLitePath           :="/home/aron/.codelite"
LinkerName             :=/usr/bin/g++-4.8 
SharedObjectLinkerName :=/usr/bin/g++-4.8 -shared -fPIC
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
ObjectsFileList        :="Controller.txt"
PCHCompileFlags        :=
MakeDirCommand         :=mkdir -p
LinkOptions            :=  
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). 
IncludePCH             := 
RcIncludePath          := 
Libs                   := $(LibrarySwitch)hiredis $(LibrarySwitch)sqlite3 
ArLibs                 :=  "hiredis" "sqlite3" 
LibPath                := $(LibraryPathSwitch). 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := /usr/bin/ar rcu
CXX      := /usr/bin/g++-4.8 
CC       := /usr/bin/gcc-4.8 
CXXFLAGS :=  -g -O0 -Wall $(Preprocessors)
CFLAGS   :=  -g -O0 -Wall $(Preprocessors)
ASFLAGS  := 
AS       := /usr/bin/as 


##
## User defined environment variables
##
CodeLiteDir:=/usr/share/codelite
Objects0=$(IntermediateDirectory)/main.c$(ObjectSuffix) $(IntermediateDirectory)/libss_ABE_IoPi.c$(ObjectSuffix) $(IntermediateDirectory)/LIBS_redis_helper.c$(ObjectSuffix) $(IntermediateDirectory)/LIBS_Core.c$(ObjectSuffix) $(IntermediateDirectory)/LIBS_Helpers.c$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild
all: $(OutputFile)

$(OutputFile): $(IntermediateDirectory)/.d $(Objects) 
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects0)  > $(ObjectsFileList)
	$(LinkerName) $(OutputSwitch)$(OutputFile) @$(ObjectsFileList) $(LibPath) $(Libs) $(LinkOptions)

$(IntermediateDirectory)/.d:
	@test -d ./Debug || $(MakeDirCommand) ./Debug

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/main.c$(ObjectSuffix): main.c $(IntermediateDirectory)/main.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/aron/Desktop/Test_area/Rig project/Controller/main.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/main.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/main.c$(DependSuffix): main.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/main.c$(ObjectSuffix) -MF$(IntermediateDirectory)/main.c$(DependSuffix) -MM "main.c"

$(IntermediateDirectory)/main.c$(PreprocessSuffix): main.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/main.c$(PreprocessSuffix) "main.c"

$(IntermediateDirectory)/libss_ABE_IoPi.c$(ObjectSuffix): ../libss/ABE_IoPi.c $(IntermediateDirectory)/libss_ABE_IoPi.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/aron/Desktop/Test_area/Rig project/libss/ABE_IoPi.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/libss_ABE_IoPi.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/libss_ABE_IoPi.c$(DependSuffix): ../libss/ABE_IoPi.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/libss_ABE_IoPi.c$(ObjectSuffix) -MF$(IntermediateDirectory)/libss_ABE_IoPi.c$(DependSuffix) -MM "../libss/ABE_IoPi.c"

$(IntermediateDirectory)/libss_ABE_IoPi.c$(PreprocessSuffix): ../libss/ABE_IoPi.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/libss_ABE_IoPi.c$(PreprocessSuffix) "../libss/ABE_IoPi.c"

$(IntermediateDirectory)/LIBS_redis_helper.c$(ObjectSuffix): ../../LIBS/redis_helper.c $(IntermediateDirectory)/LIBS_redis_helper.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/aron/Desktop/Test_area/LIBS/redis_helper.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/LIBS_redis_helper.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/LIBS_redis_helper.c$(DependSuffix): ../../LIBS/redis_helper.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/LIBS_redis_helper.c$(ObjectSuffix) -MF$(IntermediateDirectory)/LIBS_redis_helper.c$(DependSuffix) -MM "../../LIBS/redis_helper.c"

$(IntermediateDirectory)/LIBS_redis_helper.c$(PreprocessSuffix): ../../LIBS/redis_helper.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/LIBS_redis_helper.c$(PreprocessSuffix) "../../LIBS/redis_helper.c"

$(IntermediateDirectory)/LIBS_Core.c$(ObjectSuffix): ../../LIBS/Core.c $(IntermediateDirectory)/LIBS_Core.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/aron/Desktop/Test_area/LIBS/Core.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/LIBS_Core.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/LIBS_Core.c$(DependSuffix): ../../LIBS/Core.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/LIBS_Core.c$(ObjectSuffix) -MF$(IntermediateDirectory)/LIBS_Core.c$(DependSuffix) -MM "../../LIBS/Core.c"

$(IntermediateDirectory)/LIBS_Core.c$(PreprocessSuffix): ../../LIBS/Core.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/LIBS_Core.c$(PreprocessSuffix) "../../LIBS/Core.c"

$(IntermediateDirectory)/LIBS_Helpers.c$(ObjectSuffix): ../../LIBS/Helpers.c $(IntermediateDirectory)/LIBS_Helpers.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/aron/Desktop/Test_area/LIBS/Helpers.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/LIBS_Helpers.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/LIBS_Helpers.c$(DependSuffix): ../../LIBS/Helpers.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/LIBS_Helpers.c$(ObjectSuffix) -MF$(IntermediateDirectory)/LIBS_Helpers.c$(DependSuffix) -MM "../../LIBS/Helpers.c"

$(IntermediateDirectory)/LIBS_Helpers.c$(PreprocessSuffix): ../../LIBS/Helpers.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/LIBS_Helpers.c$(PreprocessSuffix) "../../LIBS/Helpers.c"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) ./Debug/*$(ObjectSuffix)
	$(RM) ./Debug/*$(DependSuffix)
	$(RM) $(OutputFile)
	$(RM) "../.build-debug/Controller"


