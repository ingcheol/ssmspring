package edu.sm.app.service;

import edu.sm.app.dto.Admin;
import edu.sm.app.repository.AdminRepository;
import edu.sm.app.repository.CateRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminService implements SmService<Admin, String> {

    final AdminRepository adminRepository;

    @Override
    public void register(Admin admin) throws Exception {
        adminRepository.insert(admin);
    }

    @Override
    public void modify(Admin admin) throws Exception {
        adminRepository.update(admin);
    }

    @Override
    public void remove(String string) throws Exception {
        adminRepository.delete(string);
    }

    @Override
    public List<Admin> get() throws Exception {
        return adminRepository.selectAll();
    }

    @Override
    public Admin get(String string) throws Exception {
        return adminRepository.select(string);
    }
}