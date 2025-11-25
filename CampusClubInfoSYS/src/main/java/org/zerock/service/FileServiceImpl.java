package org.zerock.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.FileVO;
import org.zerock.mapper.FileMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class FileServiceImpl implements FileService {

    @Setter(onMethod_ = @Autowired)
    private FileMapper mapper;

    @Override
    public FileVO getFile(Long file_id) {
        log.info("get file......" + file_id);
        return mapper.getFile(file_id);
    }

    @Override
    public int deleteFile(Long file_id) {
        log.info("delete file......" + file_id);
        return mapper.delete(file_id);
    }
}