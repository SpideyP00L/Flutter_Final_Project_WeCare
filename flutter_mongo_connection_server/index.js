const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const SERVER_NAME = 'Flutter_Final_Project';
const PORT = 9002;
const HOST = '127.0.0.1';

const app = express();
app.use(express.json());
app.use(cors());

const uristring = 'mongodb+srv://admin:admin@cluster0.zxf4zp4.mongodb.net/';

const nurseSchema = new mongoose.Schema({
  Nurse_Full_Name: String,
  Nurse_Email: String,
  Nurse_Password: String,
});

const Nurse = mongoose.model('NurseNewLogin', nurseSchema);

const doctorSchema = new mongoose.Schema({
    Doctor_Full_Name: String,
    Doctor_Email: String,
    Doctor_Password: String,
  });
  
const Doctor = mongoose.model('DoctorNewLogin', doctorSchema);

const patientSchema = new mongoose.Schema({
  _id: { type: mongoose.Schema.Types.ObjectId, auto: true},
  Patient_Name: String,
  Patient_Age: Number,
  Patient_Address: String,
  Patient_Gender: String,
  Patient_Phone_Number: String,
  Tests: {
    Blood_Pressure: Number,
    Heart_Rate: Number,
    Respiratory_Rate: Number,
    Oxygen_Saturation: Number,
    Body_Temperature: Number
  }
});


const Patient = mongoose.model('NewPatientData', patientSchema);

mongoose.connect(uristring, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log(`Connected to database: ${uristring}`))
  .catch(err => console.error('Connection error:', err));

app.post('/api/nurse/register', async (req, res) => {
  try {
    console.log('Received data:', req.body);

    const { Nurse_Full_Name, Nurse_Email, Nurse_Password } = req.body;

    const nurse = new Nurse({ Nurse_Full_Name, Nurse_Email, Nurse_Password });
    await nurse.save();

    console.log('Nurse data saved:', nurse);

    res.status(201).json({ message: 'Nurse registered successfully' });
  } catch (error) {
    console.error('Error registering nurse:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Doctor registation Logic
app.post('/api/doctor/register', async (req, res) => {
    try {
      console.log('Received data:', req.body);
  
      const { Doctor_Full_Name, Doctor_Email, Doctor_Password } = req.body;
  
      const doctor = new Doctor({ Doctor_Full_Name, Doctor_Email, Doctor_Password });
      await doctor.save();
  
      console.log('Doctor data saved:', doctor);
  
      res.status(201).json({ message: 'Doctor registered successfully' });
    } catch (error) {
      console.error('Error registering doctor:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  });

// Nurse login logic
app.post('/api/nurse/login', async (req, res) => {
  try {
    const { Nurse_Email, Nurse_Password } = req.body;
    const nurse = await Nurse.findOne({ Nurse_Email });

    if (!nurse) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    // Compare the entered password with the stored password directly
    if (Nurse_Password !== nurse.Nurse_Password) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    res.status(200).json({ message: 'Login successful' });
  } catch (error) {
    console.error('Error during nurse login:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});


app.get('/api/nurse/name', async (req, res) => {
  try {
    const { email } = req.query;
    const nurse = await Nurse.findOne({ Nurse_Email: email });

    if (!nurse) {
      return res.status(404).json({ error: 'Nurse not found' });
    }

    res.status(200).json({ Nurse_Full_Name: nurse.Nurse_Full_Name });
  } catch (error) {
    console.error('Error fetching nurse name:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Doctor Login Logic
app.post('/api/doctor/login', async (req, res) => {
    try {
      const { Doctor_Email, Doctor_Password } = req.body;
      const doctor = await Doctor.findOne({ Doctor_Email });
  
      if (!doctor) {
        return res.status(401).json({ error: 'Invalid email or password' });
      }
  
      // Compare the entered password with the stored password directly
      if (Doctor_Password !== doctor.Doctor_Password) {
        return res.status(401).json({ error: 'Invalid email or password' });
      }
  
      res.status(200).json({ message: 'Login successful' });
    } catch (error) {
      console.error('Error during doctor login:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  });

// Save patient data
app.post('/api/patient/save', async (req, res) => {
  try {
    console.log('Received patient data:', req.body);

    const { Patient_Name, Patient_Age, Patient_Address, Patient_Gender, Patient_Phone_Number } = req.body;

    const patient = new Patient({ Patient_Name, Patient_Age, Patient_Address, Patient_Gender, Patient_Phone_Number, });
    await patient.save();

    console.log('Patient data saved:', patient);

    res.status(201).json({ message: 'Patient data saved successfully' });
  } catch (error) {
    console.error('Error saving patient data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Retrieve all patients
app.get('/api/patients', async (req, res) => {
  try {
    const patients = await Patient.find();

    if (!patients || patients.length === 0) {
      return res.status(404).json({ error: 'No patients found' });
    }

    const formattedPatients = patients.map(patient => {
      if (!patient.Tests || Object.keys(patient.Tests).length === 0) {
        return {
          ...patient._doc,
          Tests: 'No tests available for this patient'
        };
      }
      return patient;
    });

    res.status(200).json(formattedPatients);
  } catch (error) {
    console.error('Error fetching patients data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete All Patients
app.delete('/api/patients/delete-all', async (req, res) => {
  try {
    await Patient.deleteMany({});

    res.status(200).json({ message: 'All patients deleted successfully' });
  } catch (error) {
    console.error('Error deleting patients:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete Patient By ID
app.delete('/api/patient/delete/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const patient = await Patient.findByIdAndDelete(id);

    if (!patient) {
      return res.status(404).json({ error: 'Patient not found' });
    }

    res.status(200).json({ message: 'Patient deleted successfully', deletedPatient: patient });
  } catch (error) {
    console.error('Error deleting patient:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Find Patient By ID
app.get('/api/patient/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const patient = await Patient.findById(id);

    if (!patient) {
      return res.status(404).json({ error: 'Patient not found' });
    }

    const testData = patient.Tests;
    const testDataPresent = testData && Object.values(testData).some(value => value !== '');

    if (!testDataPresent) {
      return res.status(200).json({ 
        ...patient.toObject(), 
        Tests: 'No Test Data Is Present, Please Add Test Data' 
      });
    }

    res.status(200).json(patient);
  } catch (error) {
    console.error('Error fetching patient data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update Patient Data By ID
app.put('/api/patient/update/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { Patient_Name, Patient_Age, Patient_Address, Patient_Gender, Patient_Phone_Number, Tests } = req.body;

    const updatedPatient = await Patient.findByIdAndUpdate(id, {
      Patient_Name,
      Patient_Age,
      Patient_Address,
      Patient_Gender,
      Patient_Phone_Number,
      Tests
    }, { new: true });

    if (!updatedPatient) {
      return res.status(404).json({ error: 'Patient not found' });
    }

    res.status(200).json({ message: 'Patient data updated successfully', updatedPatient });
  } catch (error) {
    console.error('Error updating patient data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add tests to a patient by patient ID
app.post('/api/patient/add-tests/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { tests } = req.body;

    console.log(`Adding tests to patient with ID: ${id}`);
    console.log('Tests to be added:', tests);
    
    if (!tests) {
      console.log('Tests field is missing in request body');
      return res.status(400).json({ error: 'Tests field is missing in request body' });
    }
    
    const patient = await Patient.findById(id);

    if (!patient) {
      console.log(`Patient with ID ${id} not found`);
      return res.status(404).json({ error: 'Patient not found' });
    }

    // Convert test values to numbers
    Object.keys(tests).forEach(testKey => {
      tests[testKey] = parseFloat(tests[testKey]);
    });

    // Replace existing tests with new tests
    patient.Tests = tests;
    await patient.save();

    console.log(`Tests added successfully for patient with ID: ${patient._id}`);
    res.status(201).json({ message: 'Tests added successfully', updatedPatientId: patient._id });
  } catch (error) {
    console.error('Error adding tests to patient:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update tests for a patient by patient ID
app.put('/api/patient/update-tests/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { tests } = req.body;

    console.log(`Updating tests for patient with ID: ${id}`);
    console.log('Updated tests:', tests);
    
    const patient = await Patient.findById(id);

    if (!patient) {
      console.log(`Patient with ID ${id} not found`);
      return res.status(404).json({ error: 'Patient not found' });
    }

    // Convert test values to numbers
    Object.keys(tests).forEach(testKey => {
      tests[testKey] = parseFloat(tests[testKey]);
    });

    // Replace existing tests with new tests
    patient.Tests = tests;
    await patient.save();

    console.log(`Tests updated successfully for patient with ID: ${patient._id}`);
    res.status(200).json({ message: 'Tests updated successfully', updatedPatientId: patient._id });
  } catch (error) {
    console.error('Error updating tests for patient:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete tests for a patient by patient ID
app.delete('/api/patient/delete-tests/:id', async (req, res) => {
  try {
    const { id } = req.params;

    console.log(`Deleting tests for patient with ID: ${id}`);
    
    const patient = await Patient.findById(id);

    if (!patient) {
      console.log(`Patient with ID ${id} not found`);
      return res.status(404).json({ error: 'Patient not found' });
    }

    console.log('Tests to be deleted:', patient.Tests);
    
    // Remove tests object from patient document
    patient.Tests = undefined;
    await patient.save();

    console.log(`Tests deleted successfully for patient with ID: ${patient._id}`);
    res.status(200).json({ message: 'Tests deleted successfully', updatedPatientId: patient._id });
  } catch (error) {
    console.error('Error deleting tests for patient:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Retrieve Test Data Analysis for All Patients
app.get('/api/patients/analysis', async (req, res) => {
  try {
    const patients = await Patient.find();

    if (!patients || patients.length === 0) {
      return res.status(404).json({ error: 'No patients found' });
    }

    // Define normal, low, and high ranges for each test parameter
    const ranges = {
      Blood_Pressure: { low: 90, high: 140 },
      Heart_Rate: { low: 60, high: 100 },
      Respiratory_Rate: { low: 12, high: 20 },
      Oxygen_Saturation: { low: 90, high: Infinity },
      Body_Temperature: { low: 36, high: 37.5 }
    };

    const patientsAnalysis = patients.map(patient => {
      const testData = patient.Tests;
      const analysis = {};

      for (const [test, value] of Object.entries(testData)) {
        const range = ranges[test];
        if (range) {
          if (value < range.low) {
            analysis[test] = 'Low';
          } else if (value > range.high) {
            analysis[test] = 'High';
          } else {
            analysis[test] = 'Normal';
          }
        }
      }

      return { patient, analysis };
    });

    res.status(200).json(patientsAnalysis);
  } catch (error) {
    console.error('Error fetching patients data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(PORT, HOST, () => {
  console.log(`${SERVER_NAME} server running at http://${HOST}:${PORT}`);
});
