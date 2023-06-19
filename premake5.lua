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

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"%{prj.name}/vendor/spdlog/include"
	}

	-- ϵͳ����
	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines
		{
			"XE_PLATFORM_WINDOWS",
			"XE_BUILD_DLL"
		}

		-- �����ɵ�dll�ļ�copy��demo��Ŀ��
		postbuildcommands
		{
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/DemoApp")
		}

	-- ��������
	filter "configurations:Debug"
		defines "XE_DEBUG"
		symbols "On"
	
	filter "configurations:Release"
		defines "XE_RELEASE"
		optimize "On"

	filter "configurations:Dist"
		defines "XE_DIST"
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
		"XEngine/src"
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
			"XE_PLATFORM_WINDOWS"
		}

	-- ��������
	filter "configurations:Debug"
		defines "XE_DEBUG"
		symbols "On"
	
	filter "configurations:Release"
		defines "XE_RELEASE"
		optimize "On"

	filter "configurations:Dist"
		defines "XE_DIST"
		optimize "On"
	