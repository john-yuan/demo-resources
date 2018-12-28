package org.example.app;

import java.net.URL;
import java.io.IOException;
import java.util.Enumeration;

public class App01 {
    public static void main(String[] args) {
        URL url = App01.class.getResource("/config.properties");
        System.out.println("    App01: " + url);

        try {
            URL url1 = App01.getResourceInSamePackageWithClass("config.properties", App01.class);
            System.out.println("    Target: " + url1);
        } catch (IOException e) {

        }
    }

    /**
     * 获取指定 class jar 包下面的资源文件
     *
     * @param path 文件路径，相对于 classpath
     * @param clazz 同一个路径下的 class
     * @return 成功是返回 URL，失败时返回 null
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
