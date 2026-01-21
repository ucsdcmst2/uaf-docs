# JupyterHub at UCSD CMS T2

## Interactive Data Analysis with JupyterHub

JupyterHub provides a powerful web-based interactive computing environment for data analysis, code development, and visualization. The UCSD CMS T2 JupyterHub service offers significant advantages for high-energy physics research:

- **Browser-based interface**: Access sophisticated analysis tools from anywhere
- **GPU acceleration**: Perform machine learning tasks with GPU support
- **Persistent workspace**: Maintain your analysis environment between sessions
- **Pre-installed packages**: Access common HEP tools without additional setup
- **Scalable resources**: Request resources based on your computational needs

### Accessing UCSD T2 JupyterHub

1. **Navigate to the JupyterHub portal**: 
   [https://jupyter.t2.ucsd.edu](https://jupyter.t2.ucsd.edu)

2. **Authentication**: 
   - Log in with your UCSD credentials
   - For CMS users, select the "CERN" authentication option

3. **Select an Environment**:
   - **CMS Data Analysis**: Pre-configured with CMSSW, ROOT, and common HEP packages
   - **Machine Learning**: TensorFlow, PyTorch, and GPU support
   - **General Purpose**: Python scientific stack with plotting libraries

4. **Resource Allocation**:
   - Choose CPU, memory, and GPU resources based on your analysis needs
   - Standard users can access up to 8 CPU cores and 32GB memory
   - GPU access requires justification and approval

### Accessing Your Data in JupyterHub

Your JupyterHub session has direct access to CEPH storage and other UCSD T2 resources:

```python
# Access your user directory on CEPH
import os
ceph_path = "/ceph/cms/store/user/yourusername/"
files = os.listdir(ceph_path)

# Access via XRootD
import uproot
data = uproot.open("root://redirector.t2.ucsd.edu:1094//store/user/yourusername/data.root")
```

### Coming Features

The UCSD JupyterHub service is in active development with planned enhancements:

- **Collaborative notebooks**: Real-time sharing and editing
- **Enhanced visualization tools**: Integration with specialized HEP visualization libraries
- **Dask integration**: Distributed computing for large-scale analysis
- **Streamlined CMSSW integration**: Easier setup of CMS software environments

For questions or to request specific features, please contact t2support@physics.ucsd.edu.