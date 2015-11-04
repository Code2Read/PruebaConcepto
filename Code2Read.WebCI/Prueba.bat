SET RutaTFS=C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\
SET UrlTFS=https://demo.visualstudio.com/DefaultCollection/

"%RutaTFS%tf.exe" workspaces -format:brief -server:%UrlTFS% /login:demo@outlook.com
"%RutaTFS%tf.exe" workspace /new LocalRepositorio /server:%UrlTFS% /noprompt
"%RutaTFS%tf.exe" workfold /workspace:LocalRepositorio $/Repositorio/PruebaConcepto/Code2Read.WebCI D:\Temp\Build\Code2Read.WebCI
"%RutaTFS%tf.exe" workfold /unmap /workspace:LocalRepositorio $/
cd "D:\Temp\Build\Code2Read.WebCI"
D:
"%RutaTFS%tf.exe" workspaces /collection:%UrlTFS%
IF EXIST TetsResults.trx del /F TetsResults.trx
"%RutaTFS%tf.exe" get /recursive /noprompt /overwrite
"%RutaTFS%tf.exe" workspace /delete LocalRepositorio /noprompt

SET RutaMsBuild=C:\Windows\Microsoft.NET\Framework64\v4.0.30319\
"%RutaMsBuild%msbuild.exe" Code2Read.WebCI.sln

SET RutaMsCodeMetrics=C:\Program Files (x86)\Microsoft Visual Studio 12.0\Team Tools\Static Analysis Tools\FxCop\
"%RutaMsCodeMetrics%metrics.exe" /f:Code2Read.WebCI/bin/Code2Read.WebCI.dll /o:MetricsResults.xml

SET RutaMsTest=C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\
"%RutaMsTest%mstest.exe"/noisolation /testcontainer:Code2Read.WebCI.Tests\bin\Debug\Code2Read.WebCI.Tests.dll /resultsfile:TetsResults.trx

SET RutaDespliegue=C:\inetpub\wwwroot
"%RutaMsBuild%msbuild.exe" "Code2Read.WebCI/Code2Read.WebCI.csproj" /p:Platform=AnyCPU /p:RunCodeAnalysis=False;Configuration=Release;DeployOnBuild=true;deployTarget=Package;_PackageTempDir="%RutaDespliegue%";AutoParameterizationWebConfigConnectionStrings=false
