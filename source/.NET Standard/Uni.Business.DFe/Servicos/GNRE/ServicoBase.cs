﻿#if INTEROP
using System.Runtime.InteropServices;
#endif

namespace Uni.Business.DFe.Servicos.GNRE
{
    /// <summary>
    /// Classe base para os serviços da GNRE
    /// </summary>
#if INTEROP
    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Uni.Business.DFe.Servicos.GNRE.ServicoBase")]
    [ComVisible(true)]
#endif
    public abstract class ServicoBase : NFe.ServicoBase
    {
        #region Public Constructors

        /// <summary>
        /// Construtor
        /// </summary>
        public ServicoBase() : base() { }

        #endregion Public Constructors
    }
}