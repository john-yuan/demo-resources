package org.example.app;

import java.net.URL;
import java.io.IOException;
import java.util.Enumeration;

public class App01 {
    public static void main(String[] args) {
        URL url = App01.class.getResource("/config.properties");
        System.out.println(" App01-Config-Path:");
        System.out.println("   " + url);

        try {
            URL url1 = App01.getResourceInSamePackageWithClass("config.properties", App01.class);
            System.out.println(" App01-Config-Path(Using App01.getResourceInSamePackageWithClass):");
            System.out.println("   " + url1);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取指定 class jar 包下面的资源文件
     *
     * @param path 文件路径，相对于 classpath （不能以 / 开头）
     * @param clazz 同一个路径下的 class （用来限定我们要读取的文件需与这个类在同一个 jar 包）
     * @return 成功时返回文件对应的 URL，找不到时返回 null
     * @throws IOException
     */
    public static URL getResourceInSamePackageWithClass(String path, Class<?> clazz)
        throws IOException
    {
        Enumeration<URL> urls = clazz.getClassLoader().getResources(path);

        if (urls == null) {
            return null;
        }

        String clazzName = clazz.getName();
        String clazzpath = "/" + clazzName.replace(".", "/") + ".class";
        URL clazzUrl = clazz.getResource(clazzpath);

        if (clazzUrl == null) {
            return null;
        }

        String clazzAbsPath = clazzUrl.toString();
        int endIndex = clazzAbsPath.length() - clazzpath.length();
        String pkgRootPath = clazzAbsPath.substring(0, endIndex + 1);

        URL targetUrl = null;
        URL tempUrl = null;

        while (urls.hasMoreElements()) {
            tempUrl = urls.nextElement();
            if (tempUrl.toString().startsWith(pkgRootPath)) {
                targetUrl = tempUrl;
                break;
            }
        }

        return targetUrl;
    }
}
