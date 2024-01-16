﻿#if INTEROP
using System.Runtime.InteropServices;
#endif
using System.Xml;

namespace Uni.Business.DFe.Servicos.NFSe
{
    /// <summary>
    /// Enviar o XML de Cancelamento da NFSe para o webservice
    /// </summary>
#if INTEROP
    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Uni.Business.DFe.Servicos.NFSe.CancelaNota")]
    [ComVisible(true)]
#endif
    public class CancelaNota : CancelarNfse
    {
        /// <summary>
        /// Construtor
        /// </summary>
        public CancelaNota() : base()
        { }

        /// <summary>
        /// Construtor
        /// </summary>
        /// <param name="conteudoXML">Conteúdo do XML que será enviado para o WebService</param>
        /// <param name="configuracao">Objeto "Configuracoes" com as propriedade necessária para a execução do serviço</param>
        public CancelaNota(XmlDocument conteudoXML, Configuracao configuracao) : base(conteudoXML, configuracao)
        { }
    }
}