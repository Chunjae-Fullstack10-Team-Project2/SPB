package net.spb.spb.exception;

import lombok.extern.log4j.Log4j2;

@Log4j2
public class NotFoundException extends RuntimeException {
    public NotFoundException(String message, String resource, int id) {
        super(message);
        log.error("404 Not Found: {}",resource + " #" + id + " not found");
    }
}
