package br.edu.unoesc.vestock.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import br.edu.unoesc.vestock.model.Cliente;
import br.edu.unoesc.vestock.model.Loja;
import br.edu.unoesc.vestock.repository.ClienteRepository;
import br.edu.unoesc.vestock.repository.LojaRepository;

@Service
public class ClienteService {

	private final ClienteRepository clienteRepository;
	private final LojaRepository lojaRepository;

	public ClienteService(ClienteRepository clienteRepository, LojaRepository lojaRepository) {
		this.clienteRepository = clienteRepository;
		this.lojaRepository = lojaRepository;
	}

	/**
	 * Lista todos os clientes.
	 * 
	 * @param lojaId O ID da loja logada.
	 * @return Uma lista de todos os clientes.
	 */
	public List<Cliente> listarTodos(Integer lojaId) {
		return clienteRepository.findByLojaId(lojaId);
	}

	/**
	 * Busca um cliente pelo seu ID.
	 * 
	 * @param id O ID do cliente a ser buscado.
	 * @return O cliente encontrado.
	 * @throws RuntimeException Se o cliente não for encontrado.
	 */
	public Cliente buscarPorId(Integer id) {
		return clienteRepository.findById(id).orElseThrow(() -> new RuntimeException("Cliente não encontrado: " + id));
	}

	/**
	 * Busca clientes com base em um termo informado.
	 *
	 * @param lojaId O ID da loja logada.
	 * @param termo  O termo de busca
	 * @return Uma lista de clientes que correspondem ao termo de busca, ou todos os
	 *         clientes se o termo for nulo ou vazio.
	 **/
	public List<Cliente> buscar(Integer lojaId, String termo) {
		if (termo == null || termo.isBlank()) {
			return listarTodos(lojaId);
		}
		return clienteRepository.buscarPorTermo(lojaId, termo);
	}

	/**
	 * Cria um novo cliente, definindo a data de cadastro para o momento atual.
	 * 
	 * @param cliente O cliente a ser criado.
	 * @return O cliente salvo.
	 */
	public Cliente criarCliente(Cliente cliente) {
		if (cliente.getLoja() == null || cliente.getLoja().getId() == null) {
			throw new RuntimeException("Loja é obrigatória para cadastrar um cliente");
		}

		Loja loja = lojaRepository.findById(cliente.getLoja().getId())
				.orElseThrow(() -> new RuntimeException("Loja não encontrada: " + cliente.getLoja().getId()));

		cliente.setLoja(loja);
		cliente.setDataCadastro(LocalDateTime.now());
		return clienteRepository.save(cliente);
	}

	/**
	 * Atualiza um cliente existente com novos dados.
	 * 
	 * @param id   O ID do cliente a ser atualizado.
	 * @param novo O objeto cliente com os novos dados.
	 * @return O cliente atualizado.
	 */
	public Cliente atualizarCliente(Integer id, Cliente novo) {
		Cliente cliente = buscarPorId(id);

		cliente.setNome(novo.getNome());
		cliente.setEmail(novo.getEmail());
		cliente.setSexo(novo.getSexo());
		cliente.setTelefone(novo.getTelefone());
		cliente.setRua(novo.getRua());
		cliente.setBairro(novo.getBairro());
		cliente.setCidade(novo.getCidade());
		cliente.setEstado(novo.getEstado());
		cliente.setCpf(novo.getCpf());

		return clienteRepository.save(cliente);
	}

	/**
	 * Deleta um cliente pelo seu ID.
	 * 
	 * @param id O ID do cliente a ser deletado.
	 * @throws RuntimeException Se o cliente não for encontrado.
	 */
	public void deletarCliente(Integer id) {
		if (!clienteRepository.existsById(id)) {
			throw new RuntimeException("Cliente não encontrado: " + id);
		}
		clienteRepository.deleteById(id);
	}

	/**
	 * Conta o número total de clientes.
	 * 
	 * @param lojaId O ID da loja logada.
	 * @return O número total de clientes.
	 */
	public long contarClientes(Integer lojaId) {
		return clienteRepository.countByLojaId(lojaId);
	}
}