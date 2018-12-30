[![Build Status](https://travis-ci.org/john-yuan/java-demo-resources.svg?branch=master)](https://travis-ci.org/john-yuan/java-demo-resources)

此项目是一个 Java 小实验，主要用于回答下面这个问题：

**问题**：有 app-01.jar 和 app-02.jar 两个 jar 包，每个 jar 包中都有一个 config.properties 文件。现有一个 jar 包 app-03.jar，这个 jar 包没有 config.properties 这个文件。在执行 app-03.jar 的时候，我们会把 app-01.jar 和 app-02.jar 放在 classpath 中，然后在 app-03.jar 中读取 config.propreties 文件。那么这个时候我们读取到的文件是 app-01.jar 中的还是 app-02.jar 中的？

**答案**：结果是不确定的，读取到的文件可能是 app-01.jar 中的，也可能是 app-02.jar 中的。这取决于 jar 包在 classpath 中的顺序。

比如执行：

```bash
java -cp app-01.jar:app-02.jar:app-03.jar org.example.app.App03
```

和执行：

```bash
java -cp app-02.jar:app-01.jar:app-03.jar org.example.app.App03
```

结果是不一样的，具体结果请查看运行报告 [report.txt](./report.txt) 。

> 如果想获取特定包下面的文件，请使用 [ClassLoader#getResources][1] 方法获取所有地址，然后从中找到你想要的文件。
> 具体请查看示例 [App01. getResourceInSamePackageWithClass][2]。

[1]: https://docs.oracle.com/javase/8/docs/api/java/lang/ClassLoader.html#getResources-java.lang.String-

[2]: https://github.com/john-yuan/demo-resources/blob/master/code/app-01/src/org/example/app/App01.java#L21

如果你想在本机测试，请克隆这个项目，然后打开 bash 执行以下脚本文件：

```bash
./test.sh
```
