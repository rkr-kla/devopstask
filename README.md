<!DOCTYPE html>

<h1 id="devops-task">DevOps Task</h1>
<h2 id="create-a-powershell-dockerhelper-module-containing-3-cmdlets">Create a PowerShell 'DockerHelper' module containing 3 cmdlets</h2>
<ol>
<li>
<p><strong>Build-DockerImage</strong><br>
The cmdlet builds a Docker image from the <code>$Dockerfile</code> with a name <code>$Tag</code> on a remote host <code>$ComputerName</code>, where Docker is installed. If <code>$ComputerName</code> is omitted cmdlet is executed locally.<br>
Mandatory parameters:</p>
<blockquote>
<p><code>-Dockerfile</code> &lt;String&gt; (<em>path to a Dockerfile, which is used for building an image</em>)<br>
<code>-Tag</code> &lt;String&gt; (<em>Docker image name</em>)<br>
<code>-Context</code> &lt;String&gt; (<em>path to Docker context directory</em>)</p>
</blockquote>
<p>Optional parameteres:</p>
<blockquote>
<p><code>-ComputerName</code> &lt;String&gt; (<em>name of a computer, where Docker is installed</em>)</p>
</blockquote>
</li>
<li>
<p><strong>Copy-Prerequisites</strong><br>
The cmdlet copies files and/or directories from <code>$Path</code> on a local machine to <code>$ComputerName</code> local <code>$Destination</code> directory (these files could be reqired by some Dockerfiles). Assuming you have admin access to a remote host, and you are able to use admin shares <code>C$</code>, <code>D$</code>, etc.<br>
Mandatory parameters:</p>
<blockquote>
<p><code>-ComputerName</code> &lt;String&gt; (<em>name of a remote computer</em>)<br>
<code>-Path</code> &lt;String[]&gt; (<em>local path(s) where to copy files from</em>)<br>
<code>-Destination</code> &lt;String&gt; (<em>local path on a remote host where to copy files</em>)</p>
</blockquote>
</li>
<li>
<p><strong>Run-DockerContainer</strong><br>
Run container on a remote host. If <code>$ComputerName</code> is omitted cmdlet is executed locally. Returns container name.<br>
Mandatory parameters:</p>
<blockquote>
<p><code>-ImageName</code> &lt;String&gt;</p>
</blockquote>
<p>Optional parameters:</p>
<blockquote>
<p><code>-ComputerName</code> &lt;String&gt;<br>
<code>-DockerParams</code> &lt;String[]&gt;</p>
</blockquote>
<p>Outputs:\</p>
<blockquote>
<p>&lt;String&gt;<br>
Container name.</p>
</blockquote>
</li>
</ol>
<p>You can add any number of other optional parameter if it is necessary.</p>
<h2 id="using-dockerhelper-module-run-a-fibonacci-container">Using 'DockerHelper' module run a Fibonacci container</h2>
<ol>
<li>When you do not pass any parameters to the container, it outputs all Fibonacci numbers one by one every 0.5 second.</li>
<li>When you pass a number <code>n</code> to the container, it outputs only corresponding Fibonacci number - <code>X(n)</code></li>
<li>All scripts must be written in PowerShell</li>
</ol>
<p>The outcome of this task are:</p>
<ol>
<li><code>Dockerfile</code></li>
<li>all other files required to build the docker image (if applicable)</li>
</ol>
