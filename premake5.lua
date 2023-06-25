-- ��������
workspace "XEngine"
	-- �ܹ�
	architecture "x64"
	startproject "DemoApp"
	-- ��������
	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}
-- ���Ŀ¼
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"



-- Include directories relative to root folder (Solution Directories)
IncludeDir = {}
IncludeDir["GLFW"] = "XEngine/vendor/GLFW/include"
IncludeDir["Glad"] = "XEngine/vendor/Glad/include"
IncludeDir["ImGui"] = "XEngine/vendor/imgui"
IncludeDir["glm"] = "XEngine/vendor/glm"

include "XEngine/vendor/GLFW"
include "XEngine/vendor/Glad"
include "XEngine/vendor/imgui"

-- ������Ŀ
project "XEngine"
	-- λ��
	location "XEngine"
	-- ����.dll
	kind "SharedLib"
	-- ��������
	language "C++"
	staticruntime "off"

	-- Ŀ�����Ŀ¼
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	-- �м����Ŀ¼
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	-- Ԥ����ͷ�ļ�
	pchheader "Pch.h"
	pchsource "XEngine/src/Pch.cpp"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/vendor/glm/glm/**.hpp",
		"%{prj.name}/vendor/glm/glm/**.inl"
	}

	defines
	{
		"_CRT_SECURE_NO_WARNINGS",
		"GLFW_INCLUDE_NONE"
	}

	includedirs
	{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.ImGui}",
		"%{IncludeDir.glm}"
	}

	links
	{
		"GLFW",
		"Glad",
		"ImGui",
		-- Reason Why add Dwmapi.lib : https://stackoverflow.com/questions/10727627/dwmextendframeintoclientarea-dosent-work
		'Dwmapi.lib',
		"opengl32.lib"
	}

	-- ϵͳ����
	filter "system:windows"
		cppdialect "C++17"
		systemversion "latest"

		defines
		{
			"XENGINE_PLATFORM_WINDOWS",
			"XENGINE_BUILD_DLL"
		}

		-- �����ɵ�dll�ļ�copy��demo��Ŀ��
		postbuildcommands
		{
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/DemoApp")
		}

	-- ��������
	filter "configurations:Debug"
		defines "XENGINE_DEBUG"
		buildoptions "/MDd"
		symbols "On"
	
	filter "configurations:Release"
		defines "XENGINE_RELEASE"
		buildoptions "/MD"
		optimize "On"

	filter "configurations:Dist"
		defines "XENGINE_DIST"
		buildoptions "/MD"
		optimize "On"
	
-- Ӧ����Ŀ
project "DemoApp"
	-- λ��
	location "DemoApp"
	-- ���Ϳ���̨Ӧ��
	kind "ConsoleApp"
	-- ��������
	language "C++"

	-- Ŀ�����Ŀ¼
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	-- �м����Ŀ¼
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")


	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"XEngine/vendor/spdlog/include",
		"XEngine/src",
		"XEngine/vendor",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.ImGui}",
		"%{IncludeDir.glm}"
	}

	-- ������Ŀ
	links
	{
		"XEngine"
	}

	-- ϵͳ����
	filter "system:windows"
		cppdialect "C++17"
		systemversion "latest"

		defines
		{
			"XENGINE_PLATFORM_WINDOWS"
		}

	-- ��������
	filter "configurations:Debug"
		defines "XENGINE_DEBUG"
		runtime "Debug"
		symbols "On"
	
	filter "configurations:Release"
		defines "XENGINE_RELEASE"
		runtime "Release"
		optimize "On"

	filter "configurations:Dist"
		defines "XENGINE_DIST"
		runtime "Release"
		optimize "On"
	