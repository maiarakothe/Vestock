package br.edu.unoesc.vestock.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import br.edu.unoesc.vestock.model.Fornecedor;
import br.edu.unoesc.vestock.repository.FornecedorRepository;

@Service
public class FornecedorService {

	private final FornecedorRepository fornecedorRepository;

	public FornecedorService(FornecedorRepository fornecedorRepository) {
		this.fornecedorRepository = fornecedorRepository;
	}

	/**
	 * Lista todos os fornecedores.
	 * 
	 * @return Uma lista de todos os fornecedores.
	 */
	public List<Fornecedor> listarTodos() {
		return fornecedorRepository.findAll();
	}

	/**
	 * Busca um fornecedor pelo seu ID.
	 * 
	 * @param id O ID do fornecedor a ser buscado.
	 * @return O fornecedor encontrado.
	 * @throws RuntimeException Se o fornecedor não for encontrado.
	 */
	public Fornecedor buscarPorId(Integer id) {
		Optional<Fornecedor> fornecedor = fornecedorRepository.findById(id);

		if (fornecedor.isPresent()) {
			return fornecedor.get();
		} else {
			throw new RuntimeException("Fornecedor não encontrado: " + id);
		}
	}

	/**
	 * Cria um novo fornecedor.
	 * 
	 * @param fornecedor O fornecedor a ser criado.
	 * @return O fornecedor salvo.
	 */
	public Fornecedor criarFornecedor(Fornecedor fornecedor) {
		return fornecedorRepository.save(fornecedor);
	}

	/**
	 * Atualiza um fornecedor existente com novos dados.
	 * 
	 * @param id                   O ID do fornecedor a ser atualizado.
	 * @param fornecedorAtualizado O objeto fornecedor com os novos dados.
	 * @return O fornecedor atualizado.
	 * @throws RuntimeException Se o fornecedor não for encontrado.
	 */
	public Fornecedor atualizarFornecedor(Integer id, Fornecedor fornecedorAtualizado) {
		Fornecedor fornecedorExistente = buscarPorId(id);

		fornecedorExistente.setNome(fornecedorAtualizado.getNome());
		fornecedorExistente.setEmail(fornecedorAtualizado.getEmail());
		fornecedorExistente.setSexo(fornecedorAtualizado.getSexo());
		fornecedorExistente.setTelefone(fornecedorAtualizado.getTelefone());
		fornecedorExistente.setRua(fornecedorAtualizado.getRua());
		fornecedorExistente.setBairro(fornecedorAtualizado.getBairro());
		fornecedorExistente.setCidade(fornecedorAtualizado.getCidade());
		fornecedorExistente.setEstado(fornecedorAtualizado.getEstado());
		fornecedorExistente.setCnpj(fornecedorAtualizado.getCnpj());
		fornecedorExistente.setNomeFantasia(fornecedorAtualizado.getNomeFantasia());

		return fornecedorRepository.save(fornecedorExistente);
	}

	/**
	 * Deleta um fornecedor pelo seu ID.
	 * 
	 * @param id O ID do fornecedor a ser deletado.
	 * @throws RuntimeException Se o fornecedor não for encontrado.
	 */
	public void deletarFornecedor(Integer id) {
		Fornecedor fornecedor = buscarPorId(id);
		fornecedorRepository.delete(fornecedor);
	}
}