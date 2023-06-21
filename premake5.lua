-- ��������
workspace "XEngine"
	-- �ܹ�
	architecture "x64"
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
IncludeDir["glm"] = "XEngine/vendor/glm"

include "XEngine/vendor/GLFW"
include "XEngine/vendor/Glad"

-- ������Ŀ
project "XEngine"
	-- λ��
	location "XEngine"
	-- ����.dll
	kind "SharedLib"
	-- ��������
	language "C++"

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
		"%{IncludeDir.glm}"
	}

	links
	{
		"GLFW",
		"Glad",
		'Dwmapi.lib',
		"opengl32.lib"
	}

	-- ϵͳ����
	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
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
		symbols "On"
	
	filter "configurations:Release"
		defines "XENGINE_RELEASE"
		optimize "On"

	filter "configurations:Dist"
		defines "XENGINE_DIST"
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
		staticruntime "On"
		systemversion "latest"

		defines
		{
			"XENGINE_PLATFORM_WINDOWS"
		}

	-- ��������
	filter "configurations:Debug"
		defines "XENGINE_DEBUG"
		symbols "On"
	
	filter "configurations:Release"
		defines "XENGINE_RELEASE"
		optimize "On"

	filter "configurations:Dist"
		defines "XENGINE_DIST"
		optimize "On"
	