import { useState } from 'react';
import { MdInsertPhoto } from 'react-icons/md';
import './App.css';
import Options from './components/Options';
import Toast from './components/Toast';
import Result from './components/Result';
import axios from 'axios';

export default function App() {
  const [isShowToast, setIsShowToast] = useState(false);
  const [message, setMessage] = useState('');
  const [status, setStatus] = useState('success');
  const [enhancedImage, setEnhancedImage] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmitForm = (model, useGPU, useCPUeGPU, file) => {
    if (!file) {
      showToast("You didn't upload an image!", 'fail', 3000);
    }

    setIsLoading(true);
    axios({
      method: 'POST',
      url: 'http://127.0.0.1:5000/enhance',
      data: { file, model, use_gpu: useGPU, use_cpu_egpu: useCPUeGPU },
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    })
      .then((res) => {
        const output_path = '/' + res.data.output_path.split('public\\')[1];
        setEnhancedImage(output_path);
        showToast('Your image has been enhanced!', 'success', 3000);
      })
      .catch(() => {
        showToast('Fail to enhance your image!', 'fail', 3000);
      })
      .finally(() => {
        setIsLoading(false);
      });
  };

  // Timeout will be counted in miliseconds
  const showToast = (message, status, timeout) => {
    if (!isShowToast) {
      setMessage(message);
      setStatus(status);
      setIsShowToast(true);

      setTimeout(() => {
        setIsShowToast(false);
      }, timeout);
    }
  };

  return (
    <>
      {isShowToast && <Toast message={message} status={status} />}
      <h1 id='title'>
        <MdInsertPhoto /> Enhance and Upscale your Anime Image
      </h1>
      <div className='container'>
        <Options
          showToast={showToast}
          handleSubmitForm={handleSubmitForm}
          isLoading={isLoading}
        />
        <Result image={enhancedImage ? enhancedImage : undefined} />
      </div>
    </>
  );
}
