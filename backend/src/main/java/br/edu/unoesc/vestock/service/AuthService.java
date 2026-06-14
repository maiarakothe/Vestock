package br.edu.unoesc.vestock.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import br.edu.unoesc.vestock.model.Loja;
import br.edu.unoesc.vestock.repository.LojaRepository;

@Service
public class AuthService {

    private final LojaRepository lojaRepository;
    private final BCryptPasswordEncoder encoder;

    public AuthService(LojaRepository lojaRepository) {
        this.lojaRepository = lojaRepository;
        this.encoder = new BCryptPasswordEncoder();
    }

    /**
     * Realiza o login da loja.
     */
    public Loja login(String email, String senha) {

        Loja loja = lojaRepository.findByEmail(email)
                .orElseThrow(() ->
                        new RuntimeException("E-mail não encontrado"));

        if (!encoder.matches(senha, loja.getSenha())) {
            throw new RuntimeException("Senha inválida");
        }

        return loja;
    }

    /**
     * Cria uma nova conta de loja.
     */
    public Loja cadastrar(Loja loja) {

        if (lojaRepository.findByEmail(loja.getEmail()).isPresent()) {
            throw new RuntimeException("Já existe uma loja cadastrada com este e-mail");
        }

        loja.setSenha(encoder.encode(loja.getSenha()));

        return lojaRepository.save(loja);
    }
}