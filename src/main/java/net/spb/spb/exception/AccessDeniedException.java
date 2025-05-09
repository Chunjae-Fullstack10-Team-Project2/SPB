package net.spb.spb.exception;

import lombok.extern.log4j.Log4j2;

@Log4j2
public class AccessDeniedException extends RuntimeException {
    public AccessDeniedException(String message, String resource, int id) {
        super(message);
        log.error("403 Forbidden: {}",resource + " #" + id + " access denied");
    }
}
