package br.edu.unoesc.vestock.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrimaryKeyJoinColumn;
import jakarta.persistence.Table;

/**
 * Representa um funcionário.
 */
@Entity
@Table(name = "funcionario")
@PrimaryKeyJoinColumn(name = "codpes")
public class Funcionario extends Pessoa {

	/** CPF do funcionário. */
	@Column(name = "cpffun", length = 14, nullable = false, unique = true)
	private String cpf;

	/** Cargo ou função. */
	@Column(name = "carfun", length = 50)
	private String cargo;

	/** Data de admissão. */
	@Column(name = "datadmfun")
	private LocalDateTime dataAdmissao;
	
	@ManyToOne
	@JoinColumn(name = "codloj", nullable = false)
	private Loja loja;

	public Funcionario() {

	}

	public Funcionario(Integer id, String nome, String email, Character sexo, String telefone, String rua,
			String bairro, String cidade, String estado, String cpf, String cargo, LocalDateTime dataAdmissao) {
		super(id, nome, email, sexo, telefone, rua, bairro, cidade, estado);
		this.cpf = cpf;
		this.cargo = cargo;
		this.dataAdmissao = dataAdmissao;
	}

	// Getters e Setters

	public String getCpf() {
		return cpf;
	}

	public void setCpf(String cpf) {
		this.cpf = cpf;
	}

	public String getCargo() {
		return cargo;
	}

	public void setCargo(String cargo) {
		this.cargo = cargo;
	}

	public LocalDateTime getDataAdmissao() {
		return dataAdmissao;
	}

	public void setDataAdmissao(LocalDateTime dataAdmissao) {
		this.dataAdmissao = dataAdmissao;
	}
	
	public Loja getLoja() {
	    return loja;
	}

	public void setLoja(Loja loja) {
	    this.loja = loja;
	}
}
