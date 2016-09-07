using UnityEngine;
using UnityEditor;
using System.Linq;

namespace GradleTest
{
    public static class BatchBuild
    {
        public static void Build()
        {
            EditorApplication.Exit(DoBuild());
        }

        static int DoBuild()
        {
            Debug.Log("Build Start");
            var options = BuildOptions.SymlinkLibraries
                          | BuildOptions.Development
                          | BuildOptions.AllowDebugging
                          | BuildOptions.AcceptExternalModificationsToPlayer; // このオプションでプラットフォームのプロジェクトが生成される

            var scenes = EditorBuildSettings.scenes.Where(s => s.enabled).ToArray();

            PlayerSettings.bundleIdentifier = "com.example.gradletest";
            PlayerSettings.bundleVersion = "1";
            PlayerSettings.productName = "Gradle Test";
            PlayerSettings.Android.bundleVersionCode = 1;
            PlayerSettings.Android.minSdkVersion = AndroidSdkVersions.AndroidApiLevel22;

            var errorMessage = BuildPipeline.BuildPlayer(scenes, "build-adt", BuildTarget.Android, options);
            if (string.IsNullOrEmpty(errorMessage))
            {
                Debug.Log("Build Success");
                return 0;
            }
            Debug.LogError("Build Failure");
            Debug.LogError(errorMessage);
            return 1;
        }

        [MenuItem("Gradle Test/Export Android Project")]
        public static void BuildMenu()
        {
            DoBuild();
        }

        [MenuItem("Gradle Test/Log Android SDK Path")]
        public static void LogAndroidSdkPathMenu()
        {
            Debug.Log("Android SDK Path: " + EditorPrefs.GetString("AndroidSdkRoot"));
        }
    }
}
