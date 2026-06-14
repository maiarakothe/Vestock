package br.edu.unoesc.vestock.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import br.edu.unoesc.vestock.model.Loja;
import br.edu.unoesc.vestock.service.AuthService;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/cadastro")
    public ResponseEntity<Loja> cadastro(
            @RequestBody Loja loja) {

        Loja criada = authService.cadastrar(loja);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(criada);
    }

    @PostMapping("/login")
    public ResponseEntity<Loja> login(
            @RequestParam String email,
            @RequestParam String senha) {

        Loja loja = authService.login(email, senha);

        return ResponseEntity.ok(loja);
    }
}