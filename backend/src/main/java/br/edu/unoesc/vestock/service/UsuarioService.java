package br.edu.unoesc.vestock.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import br.edu.unoesc.vestock.model.Funcionario;
import br.edu.unoesc.vestock.model.Usuario;
import br.edu.unoesc.vestock.repository.FuncionarioRepository;
import br.edu.unoesc.vestock.repository.UsuarioRepository;

@Service
public class UsuarioService {

	private final UsuarioRepository usuarioRepository;
	private final FuncionarioRepository funcionarioRepository;
	private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

	public UsuarioService(UsuarioRepository usuarioRepository, FuncionarioRepository funcionarioRepository) {
		this.usuarioRepository = usuarioRepository;
		this.funcionarioRepository = funcionarioRepository;
	}

	public Usuario criarUsuario(String username, String senha, Integer codpes) {
		Funcionario f = funcionarioRepository.findById(codpes)
				.orElseThrow(() -> new RuntimeException("Funcionario não encontrado"));

		Usuario u = new Usuario();
		u.setFuncionario(f);
		u.setUsername(username);
		u.setSenha(encoder.encode(senha));
		u.setAtivo(true);
		u.setDataCadastro(java.time.LocalDateTime.now());

		return usuarioRepository.save(u);
	}

	public Usuario login(String username, String senha) {
		Usuario u = usuarioRepository.findByUsername(username)
				.orElseThrow(() -> new RuntimeException("Usuario não encontrado"));

		if (!u.getAtivo())
			throw new RuntimeException("Usuario inativo");
		if (!encoder.matches(senha, u.getSenha()))
			throw new RuntimeException("Senha incorreta");

		return u;
	}
}
