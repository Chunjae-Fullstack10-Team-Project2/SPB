package net.spb.spb.util;

import org.springframework.ui.Model;

import java.util.*;

public class BreadcrumbUtil {

    public static void addBreadcrumb(Model model, LinkedHashMap<String, String> pages, Map<String, String> rootPage) {
        List<Map<String, String>> breadcrumbItems = new ArrayList<>();

        if (rootPage != null && !rootPage.isEmpty()) {
            breadcrumbItems.add(rootPage);
        }

        for (Map.Entry<String, String> entry : pages.entrySet()) {
            Map<String, String> item = new HashMap<>();
            item.put("name", entry.getKey());
            item.put("url", entry.getValue());
            breadcrumbItems.add(item);
        }

        model.addAttribute("breadcrumbItems", breadcrumbItems);
    }
}
