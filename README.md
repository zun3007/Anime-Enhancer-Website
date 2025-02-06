# 🎮 Anime Image Enhancer

A web application that enhances and upscales anime images using AI-powered super-resolution technology. The application uses EDSR (Enhanced Deep Super Resolution) models to improve image quality while preserving the unique characteristics of anime artwork.

## ✨ Features

- 🖼️ Image upscaling (2x and 3x)
- 🎨 Intelligent image enhancement
- 🚀 GPU acceleration support (NVIDIA CUDA)
- 💻 CPU/eGPU support (OpenCL)
- 🌐 Modern web interface
- 📱 Responsive design

## 🛠️ Prerequisites

- Python 3.8 or later
- Node.js 16 or later
- NVIDIA GPU (optional, for CUDA acceleration)
- Intel/AMD GPU (optional, for OpenCL acceleration)

## 🚀 Quick Start

### Windows

Using PowerShell (recommended):

```powershell
# Clone the repository
git clone [your-repo-url]
cd [your-repo-name]

# Run the setup script
.\setup_and_run.ps1
```

Using Command Prompt:

```cmd
# Clone the repository
git clone [your-repo-url]
cd [your-repo-name]

# Run the setup script
setup_and_run.bat
```

### Linux/macOS

```bash
# Clone the repository
git clone [your-repo-url]
cd [your-repo-name]

# Make the script executable
chmod +x setup_and_run.sh

# Run the setup script
./setup_and_run.sh
```

The setup script will:

1. Set up Python virtual environment
2. Install Python dependencies
3. Set up Node.js environment
4. Install frontend dependencies
5. Start both frontend and backend servers

## 📂 Project Structure

```
.
├── API/                        # Backend directory
│   ├── api.py                 # Flask API server
│   ├── enhance.py             # Image enhancement logic
│   ├── enhance_video.py       # Video enhancement logic
│   ├── EDSR_x2.pb            # 2x upscaling model
│   ├── EDSR_x3.pb            # 3x upscaling model
│   └── requirements.txt       # Python dependencies
│
├── Anime Image Enhancer UI/   # Frontend directory
│   ├── src/                  # Source code
│   ├── public/               # Public assets
│   └── package.json          # Node.js dependencies
│
├── setup_and_run.ps1         # Windows PowerShell script
├── setup_and_run.bat         # Windows CMD script
└── setup_and_run.sh          # Linux/macOS script
```

## 🌐 Usage

After running the setup script:

1. Open your browser and navigate to `http://localhost:5173`
2. Upload an anime image (JPEG, PNG, or JPG)
3. Select enhancement options:
   - Choose upscaling model (2x or 3x)
   - Enable GPU acceleration if available
4. Click "Enhance Image"
5. Download the enhanced image

## 🔧 Development

### Backend (Flask API)

- Located in the `API` directory
- Uses Flask for the REST API
- OpenCV for image processing
- EDSR models for super-resolution

### Frontend (React)

- Located in the `Anime Image Enhancer UI` directory
- Built with React and Vite
- Modern UI with responsive design
- Real-time processing feedback

## 📝 License

[Your License]

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🙏 Acknowledgments

- EDSR (Enhanced Deep Super Resolution) model
- OpenCV contributors
- React and Vite teams
