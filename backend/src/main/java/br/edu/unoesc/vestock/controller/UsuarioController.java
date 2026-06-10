package br.edu.unoesc.vestock.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import br.edu.unoesc.vestock.model.Usuario;
import br.edu.unoesc.vestock.service.UsuarioService;

@RestController
@RequestMapping("/api/auth")
public class UsuarioController {

	private final UsuarioService service;

	public UsuarioController(UsuarioService service) {
		this.service = service;
	}

	@PostMapping("/criar")
	public Usuario criar(
			@RequestParam String username,
			@RequestParam String senha,
			@RequestParam Integer codpes) {
		return service.criarUsuario(username, senha, codpes);
	}

	@PostMapping("/login")
	public String login(@RequestParam String username,
			@RequestParam String senha) {
		service.login(username, senha);
		return "Login realizado com sucesso";
	}

}
