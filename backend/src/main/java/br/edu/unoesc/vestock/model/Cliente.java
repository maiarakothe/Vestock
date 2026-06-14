package br.edu.unoesc.vestock.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrimaryKeyJoinColumn;
import jakarta.persistence.Table;

/**
 * Representa um cliente no sistema, herdando atributos de {@link Pessoa}
 */

@Entity
@Table(name = "cliente")
@PrimaryKeyJoinColumn(name = "codpes")
public class Cliente extends Pessoa {

	@Column(name = "cpfcli", nullable = false, unique = true)
	private String cpf;

	@Column(name = "datcadcli")
	private LocalDateTime dataCadastro;

	@ManyToOne
	@JoinColumn(name = "codloj", nullable = false)
	private Loja loja;

	public Cliente() {

	}

	public Cliente(Integer id, String nome, String email, Character sexo, String telefone, String rua, String bairro,
			String cidade, String estado, String cpf, LocalDateTime dataCadastro) {
		super(id, nome, email, sexo, telefone, rua, bairro, cidade, estado);
		this.cpf = cpf;
		this.dataCadastro = dataCadastro;
	}

	public String getCpf() {
		return cpf;
	}

	public void setCpf(String cpf) {
		this.cpf = cpf;
	}

	public LocalDateTime getDataCadastro() {
		return dataCadastro;
	}

	public void setDataCadastro(LocalDateTime dataCadastro) {
		this.dataCadastro = dataCadastro;
	}

	public Loja getLoja() {
		return loja;
	}

	public void setLoja(Loja loja) {
		this.loja = loja;
	}

}
