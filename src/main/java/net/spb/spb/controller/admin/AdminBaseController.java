package net.spb.spb.controller.admin;

import net.spb.spb.util.BreadcrumbUtil;
import org.springframework.ui.Model;

import java.util.LinkedHashMap;
import java.util.Map;

public abstract class AdminBaseController {
    protected static final Map<String, String> ROOT_BREADCRUMB = Map.of("name", "관리 페이지", "url", "/admin");

    protected void setBreadcrumb(Model model, Map<String, String>... pagePairs) {
        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
        for (Map<String, String> page : pagePairs) {
            pages.putAll(page);
        }
        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
    }
}
