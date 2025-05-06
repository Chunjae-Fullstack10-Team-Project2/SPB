package net.spb.spb.util;

public enum ReportRefType {
    POST("게시글"),
    LECTURE_REVIEW("강의평");
    private final String displayName;
    ReportRefType(String displayName) {this.displayName = displayName;}
    public String getDisplayName() {return displayName;}
    @Override
    public String toString() {
        return this.name();
    }
}
